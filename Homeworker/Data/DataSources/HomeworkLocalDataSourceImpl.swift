//
//  HomeworkLocalDataSourceImpl.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine
import GRDB

class HomeworkLocalDataSourceImpl: HomeworkLocalDataSource {
    
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
            try db.create(table: "homeworks") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text).notNull()
                t.column("subject", .text).notNull()
                t.column("endDate", .datetime).notNull()
                t.column("status", .text).notNull()
            }
        } completion: { _, result in
            print(result)
        }

    }
    
    func allTasksPublisher() -> AnyPublisher<[HomeworkSnapshot], Never> {
        let observation = ValueObservation.tracking { db in
            try HomeworkSnapshot.fetchAll(db)
        }
        
        return observation
            .publisher(in: db)
            .catch { _ in Empty<[HomeworkSnapshot], Never>(completeImmediately: false) }
            .subscribe(on: WorkScheduler.backgroundWorkScheduler)
            .eraseToAnyPublisher()
    }
    
    func create(homework: HomeworkSnapshot, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async { [db] in
            do {
                try db.write { db in
                    try homework.insert(db)
                }
                
                completion(.success(()))
                
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
    
    func update(id: Int64, update: HomeworkUpdateReference, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async { [db] in
            do {
                try db.inTransaction { db in
                    let hw = try HomeworkSnapshot.fetchOne(db, key: id)
                    
                    guard var homework = hw else { return .rollback }
                    
                    HomeworkMapper.mergeUpdate(with: &homework, update: update)
                    
                    try homework.update(db)
                    
                    return .commit
                }
                
                completion(.success(()))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
    
    func delete(id: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().async { [db] in
            do {
                let _ = try db.write { db in
                    try HomeworkSnapshot.deleteOne(db, key: id)
                }
                completion(.success(()))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
}
