//
//  AuthService.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import RxSwift

protocol AuthServiceType: AnyObject {
    func getUserIfNeedAnonymous() -> Observable<AppUser>
}

