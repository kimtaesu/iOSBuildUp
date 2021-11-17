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

struct QuestionPagination: Equatable {
    let docIds: [String]
    let nextPosition: Int
    var totalCount: Int {
        return self.docIds.count
    }
}
struct QuestionJoinAnswer {
    let question: QuestionDocument
    let answer: QuestionAnswer?
}

struct MyQuestionCount {
    let answerCount: Int
    let totalCount: Int
}

class FirestoreRepository {
    
    enum CollectionName: String {
        case buildUp = "build_up"
        case answers
        case users
        case subjects
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
    
    func listenQuestionPagination(subject: String?) -> Observable<QuestionPagination> {
        return self.authService.getUserIfNeedAnonymously()
            .flatMapLatest { user -> Observable<QuestionPagination> in
                let query: Query = {
                    if let subject = subject {
                        return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                            .whereField("subject", isEqualTo: subject)
                    } else {
                        return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    }
                }()
                
                return query
                    .rx
                    .listen()
                    .flatMapLatest { questions -> Observable<QuestionPagination> in
                        let questionIds = questions.documents.map { $0.documentID }
                        return Firestore.firestore().collection(CollectionName.users.rawValue)
                            .document(user.uid)
                            .collection(CollectionName.answers.rawValue)
                            .rx
                            .listen()
                            .map {
                                let answerIds = $0.documents.map { $0.documentID }
                                let nextPosition = min(answerIds.count + 1, questionIds.count)
                                
                                return QuestionPagination(
                                    docIds: questionIds.reorder(by: answerIds),
                                    nextPosition: nextPosition
                                )
                            }
                    }
            }
            .debug()
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
    
    func listenQuestion(docId: String) -> Observable<QuestionJoinAnswer> {
        self.authService.getUserIfNeedAnonymously()
            .flatMapLatest { user in
                Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    .document(docId)
                    .rx
                    .listen()
                    .map(QuestionDocument.self)
                    .flatMapLatest { question in
                        Firestore.firestore().collection(CollectionName.users.rawValue)
                            .document(user.uid)
                            .collection(CollectionName.answers.rawValue)
                            .document(docId)
                            .rx
                            .listen()
                            .mapOptional(QuestionAnswer.self)
                            .map { answer in
                                QuestionJoinAnswer(question: question, answer: answer)
                            }
                    }
            }
            .debug()
        
    }
}

extension Observable where Element == DocumentSnapshot {
    func mapOptional<T>(_ type: T.Type) -> Observable<T?> where T: Decodable {
        return self.flatMap { doc -> Observable<T?> in
            guard let data = doc.data() else {
                return .just(nil)
            }
            let object = try data.asObject(type: type)
            return .just(object)
        }
    }
    
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
