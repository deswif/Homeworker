//
//  SubjectMapper.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Foundation

class SubjectMapper {
    static func subjects(from snapshots: [SubjectSnapshot]) -> [SubjectEntity] {
        snapshots.map { SubjectEntity(name: $0.name) }
    }
}
