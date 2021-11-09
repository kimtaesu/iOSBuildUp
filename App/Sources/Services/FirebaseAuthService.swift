//
//  FirebaseAuthService.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import RxSwift
import FirebaseAuth

class FirebaseAuthService: AuthServiceType {
    
    private let authProvider = Auth.auth()
     
    func getUserIfNeedAnonymous() -> Observable<AppUser> {
        // TODO: Test Case Success, Failed, ifExist
        
        if let currentUser = authProvider.currentUser {
            return .just(AppUser(currentUser))
        } else {
            return authProvider.rx.signInAnonymously()
                .map { AppUser($0.user) }
        }
    }
}
