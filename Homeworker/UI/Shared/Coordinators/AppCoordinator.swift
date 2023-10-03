//
//  AppCoordinator.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    unowned let navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeworkCoordinator = makeHomeworkCoordinator()
        homeworkCoordinator.start()
    }
    
    private func makeHomeworkCoordinator() -> HomeworkCoordinator {
        let coordinator = HomeworkCoordinator(navigationController: navigationController)
        
        return coordinator
    }
}
