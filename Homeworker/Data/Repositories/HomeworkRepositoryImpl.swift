//
//  HomeworkRepositoryImpl.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

class HomeworkRepositoryImpl: HomeworkRepository {
    
    let localDataSource: HomeworkLocalDataSource
    
    init(localDataSource: HomeworkLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func allTasksPuiblisher() -> AnyPublisher<[SubjectEntity], Never> {
        localDataSource.allTasksPublisher().map { HomeworkMapper.subjects(from: $0) }.eraseToAnyPublisher()
    }
    
    func createHomework(title: String, subject: String, endDate: Date, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.create(homework: HomeworkSnapshot(title: title, subject: subject, endDate: endDate, status: HomeworkStatus.waiting.rawValue), completion: completion)
    }
    
    func deleteHomework(id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.delete(id: id, completion: completion)
    }
    
    func updateHomework(id: Int64, update: HomeworkUpdate, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.update(id: id, update: HomeworkMapper.updateReference(from: update), completion: completion)
    }
}
