//
//  HomeCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import XCoordinator
import UIKit

enum HomeRoute: Route {
    case home
    case buildUp
    case login
}

class HomeCoordinator: NavigationCoordinator<HomeRoute> {
  
    private let authService: AuthServiceType
    
    init(
        authService: AuthServiceType
    ) {
        self.authService = authService
        super.init(initialRoute: .buildUp)
    }
  
  override func prepareTransition(for route: HomeRoute) -> NavigationTransition {
    switch route {
    case .buildUp:
//        let dependency: UIBuildUpViewReactor.Dependency = .init(authService: self.authService, buildUpService: self.buildUpService)
//        let reactor = UIBuildUpViewReactor(dependency: dependency)
//        let viewController = UIBuildUpViewController(reactor: reactor)
//        return .push(viewController)
        return .none()
    case .home:
        let reactor = HomeViewReactor()
        let viewController = HomeViewController(reactor: reactor)
        return .push(viewController)
    case .login:
        let reactor = UISignViewController.Reactor()
        let viewController = UISignViewController(reactor: reactor)
        return .present(viewController)
    }
  }
}
