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
    func getUserIfNeedAnonymously() -> Observable<User>
    func signIn(_ credential: AuthCredential) -> Observable<User>
    func signOut() -> Observable<Void>
    func stateDidChange() -> Observable<User?>
}
