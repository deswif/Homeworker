//
//  SubjectReference.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import GRDB

struct SubjectReference: Encodable, PersistableRecord {
    var name: String?
    
    static var databaseTableName = "subjects"
}
