//
//  AppStarter.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class AppStarter {
    let scene: UIScene
    
    init(scene: UIScene) {
        self.scene = scene
    }
    
    func start() -> UIWindow {
        guard let windowScene = (scene as? UIWindowScene) else { fatalError() }
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()
        
        let appCoordinator = AppCoordinator(navigationController: navController)
        appCoordinator.start()
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
        return window
    }
}
