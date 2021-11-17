//
//  Array+Reorder.swift
//  App
//
//  Created by tyler on 2021/11/16.
//

import Foundation

extension Array where Element: Equatable {
    func reorder(by preferredOrder: [Element]) -> [Element] {

        return self.sorted { (a, b) -> Bool in
            guard let first = preferredOrder.firstIndex(of: a) else {
                return false
            }

            guard let second = preferredOrder.firstIndex(of: b) else {
                return true
            }

            return first < second
        }
    }
}

