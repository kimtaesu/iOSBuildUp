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
    
    func signIn(_ credential: AuthCredential) -> Observable<AuthDataResult> {
        self.authProvider.rx.signInAndRetrieveData(with: credential)
    }
    
    func signOut() -> Observable<Void> {
        let authProvider = self.authProvider
        return Observable.deferred {
            try authProvider.signOut()
            return .just(())
        }
    }
}
