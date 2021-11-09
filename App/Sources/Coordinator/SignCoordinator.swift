//
//  LoginCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/09.
//
import Foundation
import XCoordinator
import UIKit
import RxOptional

enum SignRoute: Route {
  case home
}

class SignCoordinator: NavigationCoordinator<SignRoute> {
  
    private let authService: AuthServiceType
    
    init(
        authService: AuthServiceType
    ) {
        self.authService = authService
        super.init(initialRoute: .home)
    }
    override func prepareTransition(for route: SignRoute) -> NavigationTransition {
        switch route {
        case .home:
            let reactor = UISignViewController.Reactor()
            let viewController = UISignViewController(reactor: reactor)
            return .push(viewController)
        }
    }
}
