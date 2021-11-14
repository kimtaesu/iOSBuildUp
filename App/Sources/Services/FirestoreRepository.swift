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
import  SwiftDictionaryCoding


struct MyQuestionCount {
    let answerCount: Int
    let totalCount: Int
}

class FirestoreRepository {
    
    enum CollectionName: String {
        case buildUp = "build_up"
        case answers = "answers"
        case users = "users"
        case tags = "tags"
    }
    
    private let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
    }
    
    func signIn(_ credential: AuthCredential) -> Observable<User> {
        self.authService.signIn(credential)
            .flatMap { user -> Observable<User> in
                Firestore.firestore().collection(CollectionName.users.rawValue)
                    .document(user.uid)
                    .setData([
                        "displayName": user.displayName ?? "",
                        "email": user.email ?? "",
                        "phone": user.phoneNumber ?? ""
                    ])
                return .just(user)
            }
    }
    
    func answer(docId: String, choice: CheckChoice) -> Observable<Bool> {
        return self.authService.getUserIfNeedAnonymously()
            .flatMap { user -> Observable<Bool> in
                Firestore.firestore().collection("users")
                    .document(user.uid)
                    .collection("answers")
                    .document()
                    .setData([
                        "docId": docId,
                        "timestamp": Date(),
                        "answer": choice.answer,
                        "isCorrect": choice.isCorrect
                    ])
                return .just(choice.isCorrect)
            }
    }
    
    func getQuestionsBySubject(subject: String) -> Observable<[QuestionDocument]> {
        Firestore.firestore().collection(CollectionName.buildUp.rawValue)
            .whereField("tags", arrayContains: subject)
            .rx
            .getDocuments()
            .map {
                try $0.documents.compactMap {
                    try DictionaryDecoder().decode(QuestionDocument.self, from: $0.data())
                }
            }
            .do(onError: { error in
                logger.error(error)
            })
    }
    
    func getMyCompletedCount(subject: String) -> Observable<MyQuestionCount> {
        return self.authService.getUserIfNeedAnonymously()
            .flatMap { user in
                self.getQuestionsBySubject(subject: subject)
                    .flatMap { question -> Observable<MyQuestionCount> in
                        
                        Firestore.firestore().collection(CollectionName.users.rawValue)
                            .document(user.uid)
                            .collection("answers")
                            .whereField("docId", in: question.map { $0.docId })
                            .rx
                            .getDocuments()
                            .map { MyQuestionCount(answerCount: $0.documents.count, totalCount: question.count) }
                    }
            }
            
//        return Firestore.firestore().collection(CollectionName.buildUp.rawValue)
//            .whereField("tags", arrayContains: subject)
//            .rx
//            .getDocuments()
//            .map { $0.documents.count }
    }
    
    func getAllSubjects() -> Observable<[MainCardModel]> {
        return Firestore.firestore().collection(CollectionName.tags.rawValue)
            .rx
            .getDocuments()
            .map {
                try $0.documents.compactMap {
                    try DictionaryDecoder().decode(MainCardModel.self, from: $0.data())
                }
            }
    }
}
