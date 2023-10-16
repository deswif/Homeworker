//
//  CreateHomeworkCoordinator.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import UIKit

class CreateHomeworkCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var homeworkRepository: HomeworkRepository!
    
    private var homeworkViewController: HomeworkViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = makeCreateHomeworkViewController()
        viewController.modalPresentationStyle = .pageSheet
        if let presented = navigationController.presentedViewController {
            presented.present(viewController, animated: true)
        } else {
            navigationController.present(viewController, animated: true)
        }
    }
    
    func pickSubject(completion: @escaping (SubjectEntity) -> Void) {
        let coordinator = makeSubjectListCoordinator()
        coordinator.subjectSelectedCallback = completion
        coordinator.start()
    }
    
    func homeworkCreated() {
        navigationController.dismiss(animated: true)
    }
    
    private func makeCreateHomeworkViewController() -> CreateHomeworkViewController {
        let viewController = CreateHomeworkViewController()
        let viewModel = CreateHomeworkViewModel(
            createHomeworkUseCase: CreateHomeworkUseCase(
                homeworkRepository: homeworkRepository
            )
        )
        viewController.viewModel = viewModel
        viewController.coordinator = self
        
        return viewController
    }
    
    private func makeSubjectListCoordinator() -> SubjectListCoordinator {
        let coordinator = SubjectListCoordinator(navigationController: navigationController)
        
        return coordinator
    }
}
