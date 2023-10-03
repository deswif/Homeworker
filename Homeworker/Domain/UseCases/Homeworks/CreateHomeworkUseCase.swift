//
//  CreateHomeworkUseCase.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation

class CreateHomeworkUseCase: UseCaseArguments {
    
    private let homeworkRepository: HomeworkRepository
    
    init(homeworkRepository: HomeworkRepository) {
        self.homeworkRepository = homeworkRepository
    }
    
    func call(with args: Args, completion: @escaping (Result<Void, Error>) -> Void) {
        homeworkRepository.createHomework(title: args.title, subject: args.subject, endDate: args.endDate, completion: completion)
    }
    
    struct Args {
        let title: String
        let subject: String
        let endDate: Date
    }
}
