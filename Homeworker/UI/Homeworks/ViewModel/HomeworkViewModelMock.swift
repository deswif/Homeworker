//
//  HomeworkViewModelMock.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Combine
import Foundation

class HomeworkViewModelMock: HomeworkViewModel {
    var homeworkPublisher: AnyPublisher<[SubjectTasksEntity], Never> {
        Just([SubjectTasksEntity(subject: SubjectEntity(name: "Math"), homeworks: [HomeworkEntity(id: 0, title: "do smth", subject: "Math", status: .waiting, endDate: Date().addingTimeInterval(30 * 60))])]).eraseToAnyPublisher()
    }
    
    var homeworkState: [SubjectTasksEntity] {
        [SubjectTasksEntity(subject: SubjectEntity(name: "Math"), homeworks: [HomeworkEntity(id: 0, title: "do smth", subject: "Math", status: .waiting, endDate: Date().addingTimeInterval(30 * 60))])]
    }
    
    func listenHomeworks() {
        
    }
    
    func markDone(with id: Int64) {
        
    }
    
    func deleteHomework(with id: Int64) {
        
    }
    
    func homework(with id: Int64) -> HomeworkEntity? {
        HomeworkEntity(id: 0, title: "do smth", subject: "Math", status: .done, endDate: Date().addingTimeInterval(30 * 60))
    }
    
    
}
