//
//  DeleteHomeworkUseCase.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation

class DeleteHomeworkUseCase: UseCaseArguments {
    let homeworkRepository: HomeworkRepository
    
    init(homeworkRepository: HomeworkRepository) {
        self.homeworkRepository = homeworkRepository
    }
    
    func call(with args: Args, completion: @escaping (Result<Void, Error>) -> Void) {
        homeworkRepository.deleteHomework(id: args.id, completion: completion)
    }
    
    struct Args {
        let id: Int64
    }
}
