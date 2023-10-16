//
//  GetAllSubjectsPublisherUseCase.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Combine

class GetAllSubjectsUseCase: UseCase {
    
    let subjectsRepository: SubjectRepository
    
    init(subjectsRepository: SubjectRepository) {
        self.subjectsRepository = subjectsRepository
    }
    
    
    func call(completion: @escaping (Result<[SubjectEntity], Error>) -> Void) {
        subjectsRepository.getSubjects(completion: completion)
    }
}
