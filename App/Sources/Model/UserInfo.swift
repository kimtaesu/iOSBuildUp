//
//  UserInfo.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation

struct UserInfo: Codable, CodingDictable {
    let uid: String
    let displayName: String?
    let email: String?
    let phone: String?
}
