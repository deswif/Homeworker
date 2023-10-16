//
//  SubjectRepository.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Combine

protocol SubjectRepository {
    func getSubjects(completion: @escaping (Result<[SubjectEntity], Error>) -> Void)
    
    func createSubject(name: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteSubject(with name: String, completion: @escaping (Result<Void, Error>) -> Void)
}
