//
//  HomeCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import XCoordinator
import UIKit

enum FavoriteRoute: Route {
    case home
}

class FavoriteCoordinator: NavigationCoordinator<FavoriteRoute> {
  
  init() {
    super.init(initialRoute: .home)
  }
  
  override func prepareTransition(for route: FavoriteRoute) -> NavigationTransition {
    switch route {
    case .home:
      let reactor = HomeViewReactor()
      let viewController = HomeViewController(reactor: reactor)
      return .push(viewController)
    }
  }
}
