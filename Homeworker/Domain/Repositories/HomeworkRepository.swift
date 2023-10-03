//
//  HomeworkRepository.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

protocol HomeworkRepository {
    
    func allTasksPuiblisher() -> AnyPublisher<[SubjectEntity], Never>
    
    func createHomework(title: String, subject: String, endDate: Date, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteHomework(id: Int64, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateHomework(id: Int64, update: HomeworkUpdate, completion: @escaping (Result<Void, Error>) -> Void)
}
