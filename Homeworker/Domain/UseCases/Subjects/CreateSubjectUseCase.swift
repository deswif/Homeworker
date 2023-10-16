//
//  CreateTaskUseCase.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Combine

class CreateSubjectUseCase: UseCaseArguments {
    
    let subjectRepository: SubjectRepository
    
    init(subjectRepository: SubjectRepository) {
        self.subjectRepository = subjectRepository
    }
    
    func call(with args: Args, completion: @escaping (Result<Void, Error>) -> Void) {
        subjectRepository.createSubject(name: args.name, completion: completion)
    }
    
    struct Args {
        let name: String
    }
    
}
