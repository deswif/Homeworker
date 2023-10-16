//
//  SubjectListCoordinator.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import UIKit

class SubjectListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var subjectSelectedCallback: ((SubjectEntity) -> Void)?
    
    private let subjectRepository: SubjectRepository!
    private let subjectLocalDataSource: SubjectLocalDataSource!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        subjectLocalDataSource = SubjectLocalDataSourceImpl()
        subjectRepository = SubjectRepositoryImpl(localDataSource: subjectLocalDataSource)
    }
    
    func start() {
        let viewController = makeSubjectListViewController()
        viewController.modalPresentationStyle = .pageSheet
        
        if let presented = navigationController.presentedViewController {
            presented.present(viewController, animated: true)
        } else {
            navigationController.present(viewController, animated: true)
        }
    }
    
    func subjectSelected(selection: SubjectEntity) {
        if let presented = navigationController.presentedViewController {
            presented.dismiss(animated: true)
        }
        subjectSelectedCallback?(selection)
    }
        
    
    func makeSubjectListViewController() -> SubjectListViewController {
        let viewController = SubjectListViewController(
            createSubjectUseCase: CreateSubjectUseCase(subjectRepository: subjectRepository),
            deleteSubjectUseCase: DeleteSubjectUseCase(subjectRepository: subjectRepository),
            getAllSubjectsUseCase: GetAllSubjectsUseCase(subjectsRepository: subjectRepository)
        )
        viewController.coordinator = self
        
        return viewController
    }
    
}
