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
    
    func getUserIfNeedAnonymously() -> Observable<User> {
        if let currentUser = Auth.auth().currentUser {
            return .just(currentUser)
        } else {
            return Auth.auth().rx.signInAnonymously()
                .map { $0.user }
        }
    }
    
    func signOut() -> Observable<Void> {
        return Observable.deferred {
            try  Auth.auth().signOut()
            return .just(())
        }
    }
    
    func userStateDidChange() -> Observable<User?> {
        Auth.auth().rx.stateDidChange
    }
    
    func signIn(_ credential: AuthCredential) -> Observable<User> {
        self.getUserIfNeedAnonymously()
            .flatMapLatest { oldUser in
                return Auth.auth().rx.signInAndRetrieveData(with: credential).map { $0.user }
                .flatMapLatest { newUser -> Observable<User> in
                    let userInfo = UserInfo(
                        uid: newUser.uid,
                        displayName: newUser.displayName,
                        email: newUser.email,
                        phone: newUser.phoneNumber
                    )
                    let userInfoDict = try userInfo.asDictionary()
                    
                    Firestore.firestore().collection(CollectionName.users.rawValue)
                        .document(newUser.uid)
                        .setData(userInfoDict)
                    
                    return self.migrationUser(oldUser: oldUser, newUser: newUser)
                }
            }
    }
    
    private func migrationUser(oldUser: User, newUser: User) -> Observable<User> {
        Firestore.firestore().collection(CollectionName.users.rawValue)
            .document(oldUser.uid)
            .collection(CollectionName.answers.rawValue)
            .rx
            .getDocuments()
            .mapMany(QuestionAnswer.self)
            .flatMapLatest { oldUserAnswers -> Observable<User> in
                try oldUserAnswers.forEach { answer in
                    
                    // remove old user answers
                    Firestore.firestore().collection(CollectionName.users.rawValue)
                        .document(oldUser.uid)
                        .collection(CollectionName.answers.rawValue)
                        .document(answer.docId)
                        .delete()
                    
                    // add new user answers
                    let answerDict = try answer.asDictionary()
                    Firestore.firestore().collection(CollectionName.users.rawValue)
                        .document(newUser.uid)
                        .collection(CollectionName.answers.rawValue)
                        .document(answer.docId)
                        .setData(answerDict)
                }
                return .just(newUser)
            }
    }
    
    func answer(subject: String, docId: String, choice: CheckChoice) -> Observable<Bool> {
        return self.getUserIfNeedAnonymously()
            .flatMap { user -> Observable<Bool> in
                let answer = QuestionAnswer(subject: subject, docId: docId, choice: choice)
                let answerDict = try answer.asDictionary()
                
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .collection(CollectionName.answers.rawValue)
                    .document(docId)
                    .setData(answerDict)
                            
                return .just(choice.isCorrect)
            }
    }

    func listenQuestionPagination(subject: String) -> Observable<QuestionPagination> {
        return self.getUserIfNeedAnonymously()
            .flatMapLatest { user -> Observable<QuestionPagination> in
                return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
                    .whereField("subject", isEqualTo: subject)
                    .rx
                    .listen()
                    .mapMany(QuestionDocument.self)
                    .flatMapLatest { questions -> Observable<QuestionPagination> in
                        return Firestore.firestore().collection(CollectionName.users.rawValue)
                            .document(user.uid)
                            .collection(CollectionName.answers.rawValue)
                            .whereField("subject", isEqualTo: subject)
                            .rx
                            .listen()
                            .mapMany(QuestionAnswer.self)
                            .map { answers in
                                
                                let questionAnswers = questions.map { q -> QuestionJoinAnswer in
                                    let foundAnswer = answers.first { a in q.docId == a.docId }
                                    return QuestionJoinAnswer(question: q, answer: foundAnswer)
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
        self.userStateDidChange()
            .flatMapLatest { user in
                Firestore.firestore().collection(CollectionName.subjects.rawValue)
                    .rx
                    .listen()
                    .mapMany(DocumentSubject.self)
            }
            .debug()
    }
    
    func listenDocument(docId: String) -> Observable<QuestionJoinAnswer> {
        self.getUserIfNeedAnonymously()
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
