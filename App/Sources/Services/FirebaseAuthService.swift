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
import FirebaseFirestore

class FirebaseAuthService: AuthServiceType {

    private let authProvider = Auth.auth()

    func getUserIfNeedAnonymously() -> Observable<User> {
        if let currentUser = authProvider.currentUser {
            return .just(currentUser)
        } else {
            return self.authProvider.rx.signInAnonymously()
                .map { $0.user }
        }
    }
    
    func signIn(_ credential: AuthCredential) -> Observable<User> {
        return self.authProvider.rx.signInAndRetrieveData(with: credential)
            .map { $0.user }
        
    }
    
    func signOut() -> Observable<Void> {
        let authProvider = self.authProvider
        return Observable.deferred {
            try authProvider.signOut()
            return .just(())
        }
    }
    
    func stateDidChange() -> Observable<User?> {
        return authProvider.rx.stateDidChange
    }
}
