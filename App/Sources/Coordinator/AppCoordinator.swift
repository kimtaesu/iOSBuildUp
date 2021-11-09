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
        super.init(initialRoute: .home)
    }
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .home:
            let mainCoordinator = MainTabCoordinator(buildUpService: self.buildUpService)
            return .set([mainCoordinator])
        }
    }
}
