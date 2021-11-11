//
//  FirebaseAuthService.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import RxSwift
import FirebaseAuth
import Firebase
import GoogleSignIn

class FirebaseAuthService: AuthServiceType {

    private let authProvider = Auth.auth()
     
    func getUser() -> Observable<User?> {
        return .just(self.authProvider.currentUser)
    }
    
    func getUserIfNeedAnonymous() -> Observable<User> {
        if let currentUser = self.authProvider.currentUser {
            return .just(currentUser)
        } else {
            return self.authProvider.rx.signInAnonymously()
                .map { $0.user }
        }
    }
    
    func linkAccount(_ credential: AuthCredential) -> Observable<User> {
        return self.getUserIfNeedAnonymous()
            .flatMap { $0.rx.linkAndRetrieveData(with: credential) }
            .map { $0.user }
    }
}
