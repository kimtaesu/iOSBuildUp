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

    func listenQuestionPagination(subject: String?) -> Observable<QuestionPagination> {
        let query: Query = {
            if let subject = subject {
                return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    .whereField("subject", isEqualTo: subject)
            } else {
                return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
            }
        }()
        
        return self.authService.getUserIfNeedAnonymously()
            .flatMapLatest { user -> Observable<QuestionPagination> in
                return query
                    .rx
                    .listen()
                    .mapMany(QuestionDocument.self)
                    .flatMapLatest { questions -> Observable<QuestionPagination> in
                        return Firestore.firestore().collection(CollectionName.users.rawValue)
                            .document(user.uid)
                            .collection(CollectionName.answers.rawValue)
                            .rx
                            .listen()
                            .mapMany(QuestionAnswer.self)
                            .map { answers in
                                let orderQuestions: [QuestionDocument] = questions.reorder(by: answers)
                                
                                let questionAnswers = orderQuestions.map { q -> QuestionJoinAnswer in
                                    if let foundIndex = answers.firstIndex(where: { $0.docId == q.docId }) {
                                        let answer = answers[safe: foundIndex]
                                        return QuestionJoinAnswer(question: q, answer: answer)
                                    } else {
                                        return QuestionJoinAnswer(question: q, answer: nil)
                                    }
                                }
                                return QuestionPagination(
                                    questionAnswers: questionAnswers,
                                    answerCount: answers.count
                                )
                            }
                    }
            }
            .debug()
    }
    func listenSubjects() -> Observable<[DocumentSubject]> {
        Firestore.firestore().collection(CollectionName.subjects.rawValue)
            .rx
            .listen()
            .mapMany(DocumentSubject.self)
    }
    
    func listenDocument(docId: String) -> Observable<QuestionJoinAnswer> {
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
