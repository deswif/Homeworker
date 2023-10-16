//
//  CreateHomeworkViewModel.swift
//  Homeworker
//
//  Created by Max Steshkin on 04.10.2023.
//

import Foundation
import Combine

class CreateHomeworkViewModel {
    
    private let createHomeworkUseCase: CreateHomeworkUseCase
    
    private var bag = Set<AnyCancellable>()
    
    
    private let titleTextEvents = PassthroughSubject<String, Never>()
    
    func titleChanged(with title: String) { titleTextEvents.send(title) }
    
    
    private let subjectEvents = PassthroughSubject<SubjectEntity?, Never>()
    
    func subjectChanged(with subject: SubjectEntity?) { subjectEvents.send(subject) }
    
    
    private let endDateEvents = PassthroughSubject<Date, Never>()
    
    func endDateChanged(with endDate: Date) { endDateEvents.send(endDate) }
    
    
    private let buttonAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    
    var isButtonAvailablePublisher: AnyPublisher<Bool, Never> {
        get {
            buttonAvailableSubject.eraseToAnyPublisher()
        }
    }
    
    init(createHomeworkUseCase: CreateHomeworkUseCase, bag: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.createHomeworkUseCase = createHomeworkUseCase
        self.bag = bag
    }
    
    
    func listenFields() {
        Publishers.CombineLatest3(titleTextEvents, subjectEvents, endDateEvents).map { (title, subject, endDate) in
            return !title.isEmpty && subject != nil && !subject!.name.isEmpty && endDate.timeIntervalSince1970 > Date().timeIntervalSince1970
        }.sink { [weak self] valid in
            self?.buttonAvailableSubject.send(valid)
        }.store(in: &bag)
    }
    
    func createHometask(title: String, subject: String, endDate: Date) {
        createHomeworkUseCase.call(with: .init(title: title, subject: subject, endDate: endDate)) { completion in
            switch completion {
            case .success():
                print("task created with success")
            case .failure(let error):
                print("task created with failure: \(error)")
            }
        }
    }
}
