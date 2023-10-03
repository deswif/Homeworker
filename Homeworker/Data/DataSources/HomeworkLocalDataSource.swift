//
//  HomeworkLocalDataSource.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

protocol HomeworkLocalDataSource {
    func allTasksPublisher() -> AnyPublisher<[HomeworkSnapshot], Never>
    
    func create(homework: HomeworkSnapshot, completion: @escaping (Result<Void, Error>) -> Void)
    
    func update(id: Int64, update: HomeworkUpdateReference, completion: @escaping (Result<Void, Error>) -> Void)
    
    func delete(id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
}
