//
//  HomeworkCoordinator.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class HomeworkCoordinator: Coordinator {
    unowned var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    private let homeworkRepository: HomeworkRepository
    private let homeworkLocalDataSource: HomeworkLocalDataSource
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.homeworkLocalDataSource = HomeworkLocalDataSourceImpl()
        self.homeworkRepository = HomeworkRepositoryImpl(localDataSource: homeworkLocalDataSource)
    }
    
    func start() {
        let cotroller = makeHomeworkController()
        
        navigationController.setViewControllers([cotroller], animated: true)
    }
    
    func goToDetails(of homework: HomeworkEntity) {
        let controller = makeDetailsController()
        controller.homework = homework
        
        navigationController.pushViewController(controller, animated: true)
    }
    
    func goToCreate() {
        let controller = makeCreateHomeworkController()
        controller.modalPresentationStyle = .pageSheet
        
        navigationController.present(controller, animated: true)
    }
    
    private func makeHomeworkController() -> HomeworkViewController {
        let controller = HomeworkViewController()
        
        let viewModel = HomeworkViewModel(
            getAllTasksPublisherUseCase: GetAllTasksPublisherUseCase(homeworkRepository: homeworkRepository),
            deleteHomewprkUseCase: DeleteHomeworkUseCase(homeworkRepository: homeworkRepository),
            markDoneHomeworkUseCase: MarkDoneHomeworkUseCase(homeworkRepositpry: homeworkRepository)
        )
        
        controller.coordinator = self
        controller.viewModel = viewModel
        
        return controller
    }
    
    private func makeDetailsController() -> HomeworkDetailsViewController {
        let controller = HomeworkDetailsViewController()
        
        return controller
    }
    
    private func makeCreateHomeworkController() -> CreateHomeworkViewController {
        let controller = CreateHomeworkViewController()
        let viewModel = CreateHomeworkViewModel(
            createHomeworkUseCase: CreateHomeworkUseCase(homeworkRepository: homeworkRepository)
        )
        
        controller.viewModel = viewModel
        
        return controller
    }
}
