//
//  User+FIBUser.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import FirebaseAuth

extension AppUser {
    init(_ user: FirebaseAuth.User) {
        self.uid = user.uid
    }
}
