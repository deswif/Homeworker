//
//  SubjectLocalDataSource.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Combine

protocol SubjectLocalDataSource {
    
    func readSubjects(completion: @escaping (Result<[SubjectSnapshot], Error>) -> Void)
    
    func create(subject: SubjectReference, completion: @escaping (Result<Void, Error>) -> Void)
    
    func delete(with name: String, completion: @escaping (Result<Void, Error>) -> Void)
    
}
