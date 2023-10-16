//
//  HomeworkViewModel.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

protocol HomeworkViewModel {
    
    var homeworkPublisher: AnyPublisher<[SubjectTasksEntity], Never> { get }
    
    var homeworkState: [SubjectTasksEntity] { get }
    
    func listenHomeworks()
    
    func markDone(with id: Int64)
    
    func deleteHomework(with id: Int64)
    
    func homework(with id: Int64) -> HomeworkEntity?
}

