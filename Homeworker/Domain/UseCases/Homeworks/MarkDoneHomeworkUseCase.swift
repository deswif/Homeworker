//
//  MarkDoneHomeworkUseCase.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation

class MarkDoneHomeworkUseCase: UseCaseArguments {
    
    let homeworkRepository: HomeworkRepository
    
    init(homeworkRepositpry: HomeworkRepository) {
        self.homeworkRepository = homeworkRepositpry
    }
    
    func call(with args: Args, completion: @escaping (Result<Void, Error>) -> Void) {
        homeworkRepository.updateHomework(id: args.id, update: .init(status: .done), completion: completion)
    }
    
    struct Args {
        let id: Int64
    }
}
