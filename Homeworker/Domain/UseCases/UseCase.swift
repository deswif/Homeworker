//
//  UseCase.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Combine

protocol UseCase {
    associatedtype R
    associatedtype E: Error
    
    func call(completion: @escaping (Result<R, E>) -> Void)
}

protocol UseCaseArguments {
    associatedtype Args
    associatedtype R
    associatedtype E: Error
    
    func call(with args: Args, completion: @escaping (Result<R, E>) -> Void)
}

protocol UseCasePublisher {
    associatedtype R
    associatedtype E: Error
    
    func call() -> AnyPublisher<R, E>
}

protocol UseCasePublisherArguments {
    associatedtype Args
    associatedtype R
    associatedtype E: Error
    
    func call(with args: Args) -> AnyPublisher<R, E>
}
