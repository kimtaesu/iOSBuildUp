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

class FirestoreRepository {
    
    enum CollectionName: String {
        case buildUp = "build_up"
        case answers = "answers"
        case users = "users"
        case tag = "tag"
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
                Firestore.firestore()
                    .collection(CollectionName.buildUp.rawValue)
                    .document(docId)
                    .collection(CollectionName.answers.rawValue)
                    .document(user.uid)
                    .setData([
                        "timestamp": Date(),
                        "answer": choice.answers,
                        "isCorrect": choice.isCorrect
                    ])
                return .just(choice.isCorrect)
            }
    }
    
    func getAllTags() -> Observable<[MainCardModel]> {
        let tagRef = Firestore.firestore().collection(CollectionName.tag.rawValue)
        return tagRef.rx.getDocuments().map {
            try $0.documents.compactMap {
                try DictionaryDecoder().decode(MainCardModel.self, from: $0.data())
            }
        }
        .debug("getAllTags")
//        let aaa = Firestore.firestore().collection("build_up")
//            .whereField("tag", arrayContains: tagRef.document("ABC"))
//            .getDocuments { query, error in
//                query?.documents.forEach { q in
//                    q.data().forEach { k, v in
//                        print("!!!!!!!! \(k) \(v)")
//                    }
//
//                }
//                print("!!!!!!!! ")
//                query?.documents.forEach { a in
//                    a.data().forEach { k, v in
//
//                        print("!!!!!!!!!! k: \(k) v: \(v)")
////                        let docRef = (v as? DocumentReference)
////                        print("!!!!!!!!!!! docRef: \(docRef)")
////                        docRef?.getDocument(completion: { snap1, error in
////                            snap1?.data()?.forEach { a, b in
////                                print("!!!!!!!!!!!!! a: \(a) b: \(b)")
////                            }
////                        })
//                    }
//                }
//            }
//            .collection("answers")
////            .getDocuments { query, error in
////
////                query?.documents.forEach { q in
////
////                    q.data().forEach { k, v in
////                        print("!!!!!!!!! k: \(k) v: \(v)")
////
////                    }
////                }
////                print("!!!!!!!!! \(query?.count)")
////            }
//
//        print("!!!!!!!!! aaa: \(aaa.path)")
////            .collection("answers")
////            .getDocuments { querySnapshot, error in
////                querySnapshot?.documents.forEach({ queryDocumentSnapshot in
////                print("!!!!!!!! \(queryDocumentSnapshot.data())")
////                        })
////                    }
//
////            .getDocument(completion: { doc, error in
////                print("!!!!!!!!!!!! \(doc?.data())")
////
////            })
//
//
////            .order(by: "registered_time", descending: false)
////            .whereField("tags", in: ["Swift"])
    }
}
