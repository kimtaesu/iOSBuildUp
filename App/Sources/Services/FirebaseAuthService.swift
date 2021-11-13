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

class FirebaseAuthService: AuthServiceType {

    private let authProvider = Auth.auth()

    func getUser() -> Observable<User?> {
        return .just(self.authProvider.currentUser)
    }
    
    func signIn(_ credential: AuthCredential) -> Observable<User> {
        self.authProvider.rx.signInAndRetrieveData(with: credential)
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
