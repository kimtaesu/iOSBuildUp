//
//  Array+Reorder.swift
//  App
//
//  Created by tyler on 2021/11/16.
//

import Foundation

protocol HasDocumentId {
    var docId: String { get }
}

extension Array where Element == QuestionDocument {
    func reorder(by preferredOrder: [HasDocumentId]) -> [QuestionDocument] {

        return self.sorted { (a, b) -> Bool in
            let preferredIds = preferredOrder.map { $0.docId }
            guard let first = preferredIds.firstIndex(of: a.docId) else {
                return false
            }

            guard let second = preferredIds.firstIndex(of: b.docId) else {
                return true
            }

            return first < second
        }
    }
}

