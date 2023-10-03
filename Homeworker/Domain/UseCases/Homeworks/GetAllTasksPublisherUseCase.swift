//
//  GetAllTasksPublisher.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

class GetAllTasksPublisherUseCase: UseCasePublisher {
    
    let homeworkRepository: HomeworkRepository
    
    init(homeworkRepository: HomeworkRepository) {
        self.homeworkRepository = homeworkRepository
    }
    
    func call() -> AnyPublisher<[SubjectEntity], Never> {
        homeworkRepository.allTasksPuiblisher()
    }
}
