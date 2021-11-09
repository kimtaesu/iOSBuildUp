//
//  HomeCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import XCoordinator
import UIKit


enum AppInfoRoute: Route {
    case home
}

class AppMenuCoordinator: NavigationCoordinator<AppInfoRoute> {
  
  init() {
    super.init(initialRoute: .home)
  }
  
  override func prepareTransition(for route: AppInfoRoute) -> NavigationTransition {
    switch route {
    case .home:
      let reactor = AppMenuViewReactor()
      let viewController = AppMenuViewController(reactor: reactor)
      return .push(viewController)
    }
  }
}
