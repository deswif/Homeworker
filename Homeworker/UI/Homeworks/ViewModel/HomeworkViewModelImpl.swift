//
//  HomeworkViewModelImpl.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import Combine

class HomeworkViewModelImpl: HomeworkViewModel {
    
    private let getAllTasksPublisherUseCase: GetAllTasksPublisherUseCase
    private let deleteHomeworkUseCase: DeleteHomeworkUseCase
    private let markDoneHomeworkUseCase: MarkDoneHomeworkUseCase
    
    private var bag = Set<AnyCancellable>()
    
    private let homeworksSubject = CurrentValueSubject<[SubjectTasksEntity], Never>([])
    
    var homeworkPublisher: AnyPublisher<[SubjectTasksEntity], Never> {
        get {
            homeworksSubject.eraseToAnyPublisher()
        }
    }
    
    var homeworkState: [SubjectTasksEntity] {
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
    
    func homework(with id: Int64) -> HomeworkEntity? {
        let r = homeworkState.map { subject in
            subject.homeworks
        }.first { homeworks in
            homeworks.contains { homework in
                homework.id == id
            }
        }?.first(where: { homework in
            return homework.id == id
        })
        
        
        return r
    }
}
