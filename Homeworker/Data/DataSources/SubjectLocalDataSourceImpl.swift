//
//  SubjectLocalDataSourceImpl.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Foundation
import Combine
import GRDB

class SubjectLocalDataSourceImpl: SubjectLocalDataSource {
    
    private var db: DatabaseQueue
    
    init() {
        do {
            let fileUrl = try FileManager.default
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("homeworks.sqlite")
            
            db = try DatabaseQueue(path: fileUrl.path)
            createIfNotExist()
            
        } catch (let error) {
            fatalError(error.localizedDescription)
        }
    }
    
    deinit {
        do {
            try db.close()
        } catch (let error) {
            print(error)
        }
    }
    
    private func createIfNotExist() {
        db.asyncWrite { db in
            try db.create(table: "subjects") { t in
                t.primaryKey("name", .text)
            }
        } completion: { _, result in
            print(result)
        }

    }
    
    func readSubjects(completion: @escaping (Result<[SubjectSnapshot], Error>) -> Void) {
        DispatchQueue.global().async { [db] in
            do {
                let result = try db.read { db in
                    try SubjectSnapshot.fetchAll(db)
                }
                
                completion(.success(result))
                
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
    
    func create(subject: SubjectReference, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async { [db] in
            do {
                try db.write { db in
                    try subject.insert(db)
                }
                
                completion(.success(()))
                
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
    
    func delete(with name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async { [db] in
            do {
                let _ = try db.write { db in
                    try SubjectSnapshot.deleteOne(db, key: name)
                }
                completion(.success(()))
                
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
}
