//
//  SubjectRepositoryImpl.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Foundation
import Combine

class SubjectRepositoryImpl: SubjectRepository {
    
    let localDataSource: SubjectLocalDataSource
    
    init(localDataSource: SubjectLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func getSubjects(completion: @escaping (Result<[SubjectEntity], Error>) -> Void) {
        localDataSource.readSubjects { result in
            switch result {
            case .success(let snapshots):
                completion(.success(SubjectMapper.subjects(from: snapshots)))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func createSubject(name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.create(subject: SubjectReference(name: name), completion: completion)
    }
    
    func deleteSubject(with name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.delete(with: name, completion: completion)
    }
    
    
}
