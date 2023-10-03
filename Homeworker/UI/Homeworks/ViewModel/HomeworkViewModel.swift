//
//  HomeworkViewModel.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

class HomeworkViewModel {
    
    private let getAllTasksPublisherUseCase: GetAllTasksPublisherUseCase
    private let deleteHomeworkUseCase: DeleteHomeworkUseCase
    private let markDoneHomeworkUseCase: MarkDoneHomeworkUseCase
    
    private var bag = Set<AnyCancellable>()
    
    private let homeworksSubject = CurrentValueSubject<[SubjectEntity], Never>([])
    
    var homeworkPublisher: AnyPublisher<[SubjectEntity], Never> {
        get {
            homeworksSubject.eraseToAnyPublisher()
        }
    }
    
    var homeworkState: [SubjectEntity] {
        get {
            homeworksSubject.value
        }
    }
    
    init(getAllTasksPublisherUseCase: GetAllTasksPublisherUseCase, deleteHomewprkUseCase: DeleteHomeworkUseCase, markDoneHomeworkUseCase: MarkDoneHomeworkUseCase) {
        self.getAllTasksPublisherUseCase = getAllTasksPublisherUseCase
        self.deleteHomeworkUseCase = deleteHomewprkUseCase
        self.markDoneHomeworkUseCase = markDoneHomeworkUseCase
    }
    
    func listenHomeworks() {
        getAllTasksPublisherUseCase.call()
            .receive(on: WorkScheduler.mainScheduler)
            .sink { [weak self] newHomeworks in
                self?.homeworksSubject.send(newHomeworks)
            }
            .store(in: &bag)
    }
    
    func markDone(with id: Int64) {
        markDoneHomeworkUseCase.call(with: .init(id: id)) { result in
            switch result {
            case .success():
                print("marked done with success \(id)")
            case .failure(let error):
                print("marked done with error: \(error)")
            }
        }
    }
    
    func deleteHomework(with id: Int64) {
        deleteHomeworkUseCase.call(with: .init(id: id)) { result in
            switch result {
            case .success():
                print("deleted with success \(id)")
            case .failure(let error):
                print("deleted with error: \(error)")
            }
        }
    }
    
    func changesPublisher(homework: HomeworkEntity) -> AnyPublisher<HomeworkEntity, Never> {
        let subject = homeworkPublisher
            .filter { subjects in
                subjects.contains { subject in
                    subject.name == homework.subject
                }
            }
            .map { subjects in
                subjects.first { subject in
                    subject.name == homework.subject
                }!.homeworks
            }
        
        let homeworkPublisher = subject
            .filter { homeworks in
                homeworks.contains { testedHomework in
                    testedHomework.id == homework.id
                }
            }
            .map { homeworks in
                homeworks.first { testedHomework in
                    testedHomework.id == homework.id
                }!
            }
        
        
        return homeworkPublisher.withPrevious()
            .filter { (prev, current) in
                if prev.hashValue != current.hashValue {
                    print("update: \(prev), \(current) \n")
                }
                return prev.hashValue != current.hashValue
            }
            .map { (_, current) in
                current
            }
            .eraseToAnyPublisher()
        
    }
}
