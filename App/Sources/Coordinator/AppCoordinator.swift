//
//  AppCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import XCoordinator
import UIKit

enum AppRoute: Route {
  case splash
  case home
  case login
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
  
  var window: UIWindow?
    
  init() {
    super.init(initialRoute: .splash)
  }
  override func prepareTransition(for route: AppRoute) -> NavigationTransition {
    switch route {
    case .splash:
        return .multiple(.dismissToRoot(), .set([SplashViewController(router: self.strongRouter)]))
    case .home:
        return .set([MainTabCoordinator()])
    case .login:
      return .present(MainTabCoordinator())
    }
  }
}
