//
//  CreateHomeworkViewController.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit
import Combine
import RxSwift

class CreateHomeworkViewController: UIViewController {
    
    var viewModel: CreateHomeworkViewModel!
    var coordinator: CreateHomeworkCoordinator?
    
    private let disposeBag = DisposeBag()
    private var bag = Set<AnyCancellable>()
    
    private let topSpaceGuide: UILayoutGuide = {
        let guide = UILayoutGuide()
        guide.identifier = "topSpaceGuide"
        
        return guide
    }()
    
    private let bottomSpaceGuide: UILayoutGuide = {
        let guide = UILayoutGuide()
        guide.identifier = "bottomSpaceGuide"
        
        return guide
    }()
    
    private let keyboardSpaceGuide: UILayoutGuide = {
        let guide = UILayoutGuide()
        guide.identifier = "keyboardSpaceGuide"
        
        return guide
    }()
    
    private let titleField: CreateHomeworkField = {
        let view = CreateHomeworkField()
        view.placeholder = "What to do?"
        
        return view
    }()
    
    private let subjectView: CreateHomeworkSubjectView = {
        let view = CreateHomeworkSubjectView()
        
        return view
    }()
    
    private let endDateLabel: UILabel = {
        let view = UILabel()
        view.text = "End date:"
        view.font = .preferredFont(forTextStyle: .caption1)
        view.numberOfLines = 1
        
        return view
    }()
    
    private let endDatePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.minimumDate = Date()
        view.date = {
            var date = Date()
            date.addTimeInterval(60 * 30)
            
            return date
        }()
        view.datePickerMode = .dateAndTime
        
        return view
    }()
    
    private let createButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Create", for: .normal)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenState()
        viewModel.listenFields()
        
        if #available(iOS 15.0, *) {
            if let sheet = sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
        }

        view.backgroundColor = .systemBackground
        
        view.addSubview(titleField)
        view.addSubview(subjectView)
        view.addSubview(endDateLabel)
        view.addSubview(endDatePicker)
        view.addSubview(createButton)
        
        view.addLayoutGuide(topSpaceGuide)
        view.addLayoutGuide(bottomSpaceGuide)
        view.addLayoutGuide(keyboardSpaceGuide)
        
        configureSpacers()
        configureTitleField()
        configureSubjectView()
        configureEndDatePicker()
        configureCreateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CreateHomeworkViewController.keyboardWillShowNotification(_:)),
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(CreateHomeworkViewController.keyboardWillHideNotification(_:)),
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureSpacers() {
        topSpaceGuide.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(titleField.snp.top)
        }
        
        bottomSpaceGuide.snp.makeConstraints { make in
            make.height.equalTo(topSpaceGuide)
            make.top.equalTo(endDatePicker.snp.bottom)
            make.bottom.equalTo(createButton.snp.top).priority(.low)
            make.bottom.lessThanOrEqualTo(keyboardSpaceGuide.snp.top)
        }
        
        keyboardSpaceGuide.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func configureTitleField() {
        
        titleField.rx.text.subscribe { [weak self] text in
            self?.viewModel.titleChanged(with: text!)
        }.disposed(by: disposeBag)
        
        titleField.delegate = self
        
        titleField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func configureSubjectView() {
        
        subjectView.openPicker = { [weak self] in
            self?.coordinator?.pickSubject(completion: { [weak self] subject in
                self?.updateSelectedSubject(with: subject)
            })
        }
        
        subjectView.snp.makeConstraints { make in
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.top.equalTo(titleField.snp.bottom).offset(15)
        }
    }
    
    private func configureEndDatePicker() {
        
        endDatePicker.rx.date.subscribe { [weak self] date in
            self?.viewModel.endDateChanged(with: date)
        }.disposed(by: disposeBag)
        
        viewModel.endDateChanged(with: endDatePicker.date)
        
        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleField)
            make.top.equalTo(subjectView.snp.bottom).offset(30)
            make.height.equalTo(20)
            make.width.lessThanOrEqualTo(titleField)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.centerY.equalTo(endDateLabel)
            make.leading.equalTo(endDateLabel.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualTo(titleField)
        }
    }
    
    private func configureCreateButton() {
        
        createButton.rx.tap.subscribe { [weak self, titleField, subjectView, endDatePicker] _ in
            
            self?.viewModel.createHometask(title: titleField.text!, subject: subjectView.pickedSubject!.name, endDate: endDatePicker.date)
            self?.coordinator?.homeworkCreated()
            
        }.disposed(by: disposeBag)
        
        createButton.snp.makeConstraints { make in
            make.height.equalTo(54)
            make.leading.equalTo(titleField)
            make.trailing.equalTo(titleField)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-30)
        }
    }
}

extension CreateHomeworkViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateHomeworkViewController {
    
    func listenState() {
        viewModel.isButtonAvailablePublisher.sink(receiveValue: { [weak self] isAvailable in
            self?.createButton.isEnabled = isAvailable
        }).store(in: &bag)
    }
    
    private func updateSelectedSubject(with subject: SubjectEntity) {
        viewModel.subjectChanged(with: subject)
        subjectView.pickedSubject = subject
    }
}

extension CreateHomeworkViewController {
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        else { return }
        
        let frame = frameValue.cgRectValue
        
        let options = UIView.AnimationOptions(rawValue: curve.uintValue)
        
        setFieldsFor(keyboardFrame: frame, duration: duration.doubleValue, options: options)
        
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        else { return }
        
        let options = UIView.AnimationOptions(rawValue: curve.uintValue)
        
        setFieldsFor(keyboardFrame: .zero, duration: duration.doubleValue, options: options)
    }
    
    private func setFieldsFor(keyboardFrame: CGRect, duration: TimeInterval, options: UIView.AnimationOptions) {
        
        var actualDuration: TimeInterval
        
        if duration == 0 {
            actualDuration = 0.2
        } else {
            actualDuration = duration
        }
        
        UIView.animate(withDuration: actualDuration, delay: 0, options: options) { [weak self] in
            
            self?.keyboardSpaceGuide.snp.updateConstraints { make in
                make.height.equalTo(keyboardFrame.height)
            }
            
            self?.view.layoutIfNeeded()
        }
    }
}

