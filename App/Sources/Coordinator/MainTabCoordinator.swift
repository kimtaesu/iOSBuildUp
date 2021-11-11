//
//  MainCoordinator.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import XCoordinator


enum MainRoute: Route {
    case home
    case search
    case favorite
    case appInfo
}

class MainTabCoordinator: TabBarCoordinator<MainRoute> {
  
    private let homeRouter: StrongRouter<HomeRoute>
    private let searchRouter: StrongRouter<SearchRoute>
    private let favoriteRouter: StrongRouter<FavoriteRoute>
    private let appInfoRouter: StrongRouter<AppInfoRoute>
    
    convenience init(
        authService: AuthServiceType,
        buildUpService: BuildUpServiceType
    ) {
        let homeCoordinator = HomeCoordinator(authService: authService, buildUpService: buildUpService)
        homeCoordinator.rootViewController.tabBarItem = MainTabItem.home.tabItem

        let searchCoordinator = SearchCoordinator()
        searchCoordinator.rootViewController.tabBarItem = MainTabItem.search.tabItem
        
        let favoriteCoordinator = FavoriteCoordinator()
        favoriteCoordinator.rootViewController.tabBarItem = MainTabItem.bookmark.tabItem
        
        let appInfoCoordinator = AppMenuCoordinator()
        appInfoCoordinator.rootViewController.tabBarItem = MainTabItem.menu.tabItem
        
        self.init(
            homeRouter: homeCoordinator.strongRouter,
            searchRouter: searchCoordinator.strongRouter,
            favoriteRouter: favoriteCoordinator.strongRouter,
            appInfoRouter: appInfoCoordinator.strongRouter
        )
    }

    init(
        homeRouter: StrongRouter<HomeRoute>,
        searchRouter: StrongRouter<SearchRoute>,
        favoriteRouter: StrongRouter<FavoriteRoute>,
        appInfoRouter: StrongRouter<AppInfoRoute>
    ) {
        self.homeRouter = homeRouter
        self.searchRouter = searchRouter
        self.favoriteRouter = favoriteRouter
        self.appInfoRouter = appInfoRouter
        super.init(tabs: [homeRouter, searchRouter, favoriteRouter, appInfoRouter], select: homeRouter)
        self.rootViewController.tabBar.isTranslucent = false
    }
  
    override func prepareTransition(for route: MainRoute) -> TabBarTransition {
        switch route {
        case .home:
          return .select(self.homeRouter)
        case .search:
            return .select(self.searchRouter)
        case .favorite:
            return .select(self.favoriteRouter)
        case .appInfo:
            return .select(self.appInfoRouter)
        }
    }
}
