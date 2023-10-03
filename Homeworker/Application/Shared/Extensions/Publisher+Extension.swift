//
//  Publisher+Extension.swift
//  Homeworker
//
//  Created by Max Steshkin on 05.10.2023.
//

import Combine

extension Publisher {
    func withPrevious() -> AnyPublisher<(previous: Output, current: Output), Failure> {
        scan(Optional<(Output?, Output)>.none) { ($0?.1, $1) }
            .compactMap { $0 }
            .filter({ (prev, current) in
                prev != nil
            })
            .map({ (prev, current) in
                (prev!, current)
            })
            .eraseToAnyPublisher()
    }
}
