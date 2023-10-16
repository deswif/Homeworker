//
//  SubjectListViewController.swift
//  Homeworker
//
//  Created by Max Steshkin on 14.10.2023.
//

import UIKit
import RxSwift


/*
 Here I tried to make controller without ViewModel
 */



class SubjectListViewController: UIViewController {
    
    let createSubjectUseCase: CreateSubjectUseCase
    let deleteSubjectUseCase: DeleteSubjectUseCase
    let getAllSubjectsUseCase: GetAllSubjectsUseCase
    
    private var subjects = [SubjectEntity]()
    
    private let bag = DisposeBag()
    
    typealias DataSource = UITableViewDiffableDataSource<Int, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    var coordinator: SubjectListCoordinator?
    
    var dataSource: DataSource!
    
    private lazy var subjectsTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor = .clear
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return view
    }()
    
    private let addButton: CustomButton = {
        let view = CustomButton()
        view.setTitle("Add", for: .normal)
        view.setTitleColor(.systemBlue, for: .normal)
        
        return view
    }()
    
    init(
        createSubjectUseCase: CreateSubjectUseCase,
        deleteSubjectUseCase: DeleteSubjectUseCase,
        getAllSubjectsUseCase: GetAllSubjectsUseCase
    ) {
        self.createSubjectUseCase = createSubjectUseCase
        self.deleteSubjectUseCase = deleteSubjectUseCase
        self.getAllSubjectsUseCase = getAllSubjectsUseCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *), let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
            
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(subjectsTableView)
        view.addSubview(addButton)
        
        configureTableView()
        configureAddButton()
        
        readSubjects()
    }
    
    private func configureTableView() {
        
        dataSource = DataSource(tableView: subjectsTableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .systemBackground
            cell.textLabel!.text = itemIdentifier
            
            return cell
        }
        
        applyChanges()
        
        subjectsTableView.dataSource = dataSource
        subjectsTableView.delegate = self
        
        subjectsTableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(addButton.snp.bottom).offset(10)
        }
    }
    
    private func configureAddButton() {
        
        addButton.rx.tap.subscribe { [weak self] _ in
            self?.didTapAdd()
        }.disposed(by: bag)
        
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    private func didTapAdd() {
        if #available(iOS 15.0, *), let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = .large
            }
        }
        
        let alertVC = buildAddAlert()
        
        self.present(alertVC, animated: true)
    }
    
    private func buildAddAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Add subject", message: nil, preferredStyle: .alert)
        alert.addTextField { _ in }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alert, weak self] _ in
            guard
                let field = alert?.textFields?.first,
                let text = field.text
            else { return }
            
            self?.addSubject(with: text)
        }
        
        alert.addAction(.init(title: "Cancel", style: .destructive))
        alert.addAction(addAction)
        
        return alert
    }
    
    private func applyChanges() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(subjects.map { $0.name })
        
        dataSource.apply(snapshot)
    }
    
    private func subject(in indexPath: IndexPath) -> SubjectEntity {
        subjects[indexPath.item]
    }
}

extension SubjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let subject = subject(in: indexPath)
        
        coordinator?.subjectSelected(selection: subject)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.removeSubject(in: indexPath)
        }
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            UIMenu(children: [deleteAction])
        })
    }
}

extension SubjectListViewController {
    
    private func addSubject(with name: String) {
        createSubjectUseCase.call(with: .init(name: name)) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success():
                    
                    let subject = SubjectEntity(name: name)
                    self?.subjects.append(subject)
                    self?.applyChanges()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func removeSubject(in indexPath: IndexPath) {
        let subject = subject(in: indexPath)
        deleteSubjectUseCase.call(with: .init(name: subject.name)) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success():
                    
                    self?.subjects.removeAll(where: { $0.name == subject.name })
                    self?.applyChanges()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func readSubjects() {
        getAllSubjectsUseCase.call { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let subjects):
                    
                    self?.subjects = subjects
                    self?.applyChanges()
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
