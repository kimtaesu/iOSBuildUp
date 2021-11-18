//
//  BuildUpSubject.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation

struct DocumentSubject: Codable, CodingDictable, Equatable {
    let subject: String
    let title: String
    let subtitle: String
    let thumbnail: String?
}
