//
//  AuthService.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import RxSwift
import FirebaseAuth

protocol AuthServiceType: AnyObject {
    func signIn(_ credential: AuthCredential) -> Observable<AuthDataResult>
    func signOut() -> Observable<Void>
}
