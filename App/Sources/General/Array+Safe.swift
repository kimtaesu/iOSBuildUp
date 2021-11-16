//
//  Array+Safe.swift
//  App
//
//  Created by tyler on 2021/11/16.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
