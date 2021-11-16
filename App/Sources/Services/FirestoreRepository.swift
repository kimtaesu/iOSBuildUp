//
//  FirestoreServiceType.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import Accelerate

struct MyQuestionCount {
    let answerCount: Int
    let totalCount: Int
}

class FirestoreRepository {
    
    enum CollectionName: String {
        case buildUp = "build_up"
        case questions = "questions"
        case answers = "answers"
        case users = "users"
        case tags = "tags"
    }
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func signOut() -> Observable<Void> {
        self.authService.signOut()
    }
    
    func userStateDidChange() -> Observable<User?> {
        self.authService.stateDidChange()
    }
    
    func signIn(_ credential: AuthCredential) -> Observable<User> {
        self.authService.signIn(credential)
            .flatMap { user -> Observable<User> in
                let userInfo = UserInfo(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email,
                    phone: user.phoneNumber
                )
                let userInfoDict = try userInfo.asDictionary()
                
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .setData(userInfoDict)
                
                
                
                return .just(user)
            }
    }
    
    func listenAnswer(subject: String, docId: String) -> Observable<QuestionAnswer> {
        return self.authService.getUserIfNeedAnonymously()
            .flatMapLatest { user in
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .collection(CollectionName.answers.rawValue)
                    .document(docId)
                    .rx
                    .listen()
                    .map(QuestionAnswer.self)
                    .debug()
            }
    }
    
    func answer(docId: String, choice: CheckChoice) -> Observable<Bool> {
        return self.authService.getUserIfNeedAnonymously()
            .flatMap { user -> Observable<Bool> in
                let answer = QuestionAnswer(docId: docId, choice: choice)
                let answerDict = try answer.asDictionary()
                
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .collection(CollectionName.answers.rawValue)
                    .document(docId)
                    .setData(answerDict)
                            
                return .just(choice.isCorrect)
            }
    }
    
    func getMyCompletedCount(subject: String) -> Observable<MyQuestionCount> {
        
//        return self.authService.getUserIfNeedAnonymously()
//            .flatMap { user in
//                self.getQuestionsBySubject(subject: subject)
//                    .flatMap { question -> Observable<MyQuestionCount> in
//
//                        Firestore.firestore().collection(CollectionName.users.rawValue)
//                            .document(user.uid)
//                            .collection(CollectionName.answers.rawValue)
//                            .whereField("docId", in: question.map { $0.docId })
//                            .rx
//                            .getDocuments()
//                            .map { MyQuestionCount(answerCount: $0.documents.count, totalCount: question.count) }
//                    }
//            }
        return .empty()
    }
    func getMyAnswers() -> Observable<[QuestionAnswer]> {
        self.authService.getUserIfNeedAnonymously()
            .flatMap { user in
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .collection(CollectionName.answers.rawValue)
                    .rx
                    .getDocuments()
                    .map {
                        try $0.documents.map {
                            return try $0.data().asObject(type: QuestionAnswer.self)
                        }
                    }
            }
    }
    
    func listenQuestions(subject: String) -> Observable<[QuestionDocument]> {
        self.authService.getUserIfNeedAnonymously()
            .flatMap { user -> Observable<[QuestionDocument]> in
                return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    .document(subject)
                    .collection(CollectionName.questions.rawValue)
                    .rx
                    .listen()
                    .mapMany(QuestionDocument.self)
                    .debug()
            }
    }
    
    func listenSubjects() -> Observable<[BuildUpSubject]> {
        return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
            .rx
            .listen()
            .map {
                try $0.documents.map {
                    return try $0.data().asObject(type: BuildUpSubject.self)
                }
            }
    }
    
    func listenQuestion(subject: String, docId: String) -> Observable<QuestionDocument> {
        return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
            .document(subject)
            .collection(CollectionName.questions.rawValue)
            .document(docId)
            .rx
            .listen()
            .map(QuestionDocument.self)
    }
    
    func listenQuestion(subject: String) -> Observable<QuestionDocument> {
        self.nextQuestionId(subject: subject)
        // TODO:
            .flatMap { nextDocId in
                Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    .document(subject)
                    .collection(CollectionName.questions.rawValue)
                    .document(nextDocId!)
                    .rx
                    .listen()
                    .map(QuestionDocument.self)
            }
    }
    
    func nextQuestionId(subject: String) -> Observable<String?> {
        self.authService.getUserIfNeedAnonymously()
            .flatMapLatest { user in
                
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .collection(CollectionName.answers.rawValue)
                    .rx
                    .getDocuments()
                    .map { $0.documents.map { $0.documentID } }
            }
            .flatMap { answerIds in
                Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    .document(subject)
                    .collection(CollectionName.questions.rawValue)
                    .whereField("docId", notIn: answerIds)
                    .rx
                    .getDocuments()
                    .map { $0.documents.first?.documentID }
            }
    }
}

extension Observable where Element == DocumentSnapshot {
    func map<T>(_ type: T.Type) -> Observable<T> where T: Decodable {
        return self.flatMap { doc -> Observable<T> in
            guard let data = doc.data() else {
                let error = NSError(domain: "DocumentSnapshot no data", code: -1, userInfo: nil)
                return .error(error)
            }
            let object = try data.asObject(type: type)
            return .just(object)
        }
    }
}

extension Observable where Element == QuerySnapshot {
    func mapMany<T>(_ type: T.Type) -> Observable<[T]> where T: Decodable {
        return self.map { doc -> [T] in
            return try doc.documents.map {
                return try $0.data().asObject(type: type)
            }
        }
    }
}
