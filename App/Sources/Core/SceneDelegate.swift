//
//  SceneDelegate.swift
//  asd
//
//  Created by tyler on 2021/11/07.
//

import UIKit
import RxViewController
import SnapKit
import RxSwift
import RxCocoa
import ManualLayout
import RxGesture
import Kingfisher
import RxOptional

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
      // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.backgroundColor = .white
        
        let authService: AuthServiceType = FirebaseAuthService()
        
        let fireStoreRepository: FirestoreRepository = FirestoreRepository(authService: authService)
        
        // MARK: QuestionListViewController
        let questionListViewScreen: ((_ subject: String) -> UIQuestionListViewController)! = { subject in
            let reactor = UIQuestionListViewController.Reactor(subject: subject, repository: fireStoreRepository)
            return UIQuestionListViewController(reactor: reactor)
        }
        // MARK: UIBuildUpViewController
        let buildUpViewScreen: (_ subject: String, _ docId: String?) -> UIBuildUpViewController = { subject, docId in
            let dependency = UIBuildUpViewReactor.Dependency(subject: subject, docId: docId, firestoreRepository: fireStoreRepository)
            let reactor = UIBuildUpViewController.Reactor(dependency: dependency)
            return UIBuildUpViewController(reactor: reactor, questionListViewScreen: questionListViewScreen)
        }
        
        // MARK: SplashViewController
        let splashViewController = UISplashViewController(onNext: {
            let reactor = MainViewContoller.Reactor(repository: fireStoreRepository)
            
            // MARK: MainViewController
            let viewController = UINavigationController(rootViewController: MainViewContoller(reactor: reactor, buildUpViewScreen: buildUpViewScreen))
            
            window.setRootViewController(viewController, options: .init(direction: .fade, style: .easeIn))
        })

//                let data = MainCardModel(collectionId: "Swift", title: "Swift", thumbnail: nil)
//        window.rootViewController = UINavigationController(rootViewController: questionListViewScreen(data))
        
        window.rootViewController = UINavigationController(rootViewController: questionListViewScreen("Swift"))
//        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

