//
//  AppCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import XCoordinator
import UIKit
import RxOptional

enum AppRoute: Route {
  case splash
  case home
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
  
    private let authService: AuthServiceType
    private let buildUpService: BuildUpServiceType
    
    init(
        authService: AuthServiceType,
        buildUpService: BuildUpServiceType
    ) {
        self.authService = authService
        self.buildUpService = buildUpService
        super.init(initialRoute: .splash)
    }
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .splash:
            let dependency = UISplashViewController.Reactor.Dependency(authService: self.authService, router: self.strongRouter)
            let reactor = UISplashViewController.Reactor(dependency: dependency)
            let splashViewController = UISplashViewController(reactor: reactor)
                
            return .push(splashViewController)
        case .home:
            let mainCoordinator = MainTabCoordinator(buildUpService: self.buildUpService)
            return .set([mainCoordinator])
        }
    }
}
