//
//  BDictable.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation
import SwiftDictionaryCoding
import RxSwift

protocol CodingDictable {
    
}

extension CodingDictable where Self: Encodable {
    func asDictionary() throws -> [String: Any] {
        try DictionaryEncoder().encode(self)
    }
}

extension Dictionary where Key == String, Value == Any {
    func asObject<T>(type: T.Type) throws -> T where T: Decodable {
        try DictionaryDecoder().decode(T.self, from: self)
    }
}
