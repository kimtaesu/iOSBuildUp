//
//  DocumentSnapshot+Map.swift
//  App
//
//  Created by tyler on 2021/11/18.
//

import RxSwift
import FirebaseFirestore

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
