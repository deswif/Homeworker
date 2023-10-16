//
//  HomeworkMapper.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation


class HomeworkMapper {
    static func subjectsTasks(from tasks: [HomeworkSnapshot]) -> [SubjectTasksEntity] {
        var result = OrderedDictionary<String, [HomeworkEntity]>()
        
        
        for task in tasks {
            let homework = homework(from: task)
            
            if result.keys.filter({ $0 == task.subject }).isEmpty {
                result[task.subject] = [homework]
                
            } else {
                result[task.subject]?.append(homework)
            }
        }
        
        let subjects = result.map { (key, value) in
            SubjectTasksEntity(subject: SubjectEntity(name: key), homeworks: value.sorted(by: { first, second in
                first.endDate ?? Date() < second.endDate ?? Date() || (first.status != .done && second.status == .done)
            }))
        }.sorted { first, second in
            first.subject.name < second.subject.name
        }
        
        return subjects
    }
    
    static func homework(from snapshot: HomeworkSnapshot) -> HomeworkEntity {
        HomeworkEntity(
            id: snapshot.id!,
            title: snapshot.title,
            subject: snapshot.subject,
            status: .init(rawValue: snapshot.status)!,
            endDate: snapshot.endDate
        )
    }
    
    static func updateReference(from update: HomeworkUpdate) -> HomeworkUpdateReference {
        HomeworkUpdateReference(title: update.title, subject: update.subject, endDate: update.endDate, status: update.status?.rawValue)
    }
    
    static func mergeUpdate(with snapshot: inout HomeworkSnapshot, update: HomeworkUpdateReference) {
        if let title = update.title {
            snapshot.title = title
        }
        
        if let subject = update.subject {
            snapshot.subject = subject
        }
        
        if let endDate = update.endDate {
            snapshot.endDate = endDate
        }
        
        if let status = update.status {
            snapshot.status = status
        }
    }
}
