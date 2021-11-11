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
    func getUser() -> Observable<User?>
    func getUserIfNeedAnonymous() -> Observable<User>
    func linkAccount(_ credential: AuthCredential) -> Observable<User>
}
