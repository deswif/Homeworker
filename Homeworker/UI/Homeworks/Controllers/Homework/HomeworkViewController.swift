//
//  HomeworkViewController.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Combine

class HomeworkViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, Int64>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Int64>
    
    var coordinator: HomeworkCoordinator?
    var viewModel: HomeworkViewModel!
    
    let disposeBag = DisposeBag()
    var bag = Set<AnyCancellable>()
    
    var dataSource: DataSource!
    
    private lazy var homeworkCollectionView: UICollectionView = {
        
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeCollectionLayout()
        )
        view.register(
            HomeworkCollectionViewCell.self,
            forCellWithReuseIdentifier: HomeworkCollectionViewCell.identifier
        )
        view.register(
            HomeworkSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeworkSectionHeader.identifier
        )
        
        return view
    }()
    
    private let createHomeworkButton: CreateHomeworkButton = {
        let view = CreateHomeworkButton()
        
        return view
    }()
    
    private let emptyStateLabel: UILabel = {
        let view = UILabel()
        view.text = "Nothing here"
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.textColor = .white.withAlphaComponent(0.5)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Homeworks"
        
        configureHomeworkCollectionView()
        configureCreateButton()
        configureEmptyStateLabel()
        
        listenState()
        
        viewModel.listenHomeworks()
    }
    
    private func configureHomeworkCollectionView() {
        homeworkCollectionView.delegate = self
        
        dataSource = DataSource(
            collectionView: homeworkCollectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                self?.cellProvider(collectionView: collectionView, indexPath: indexPath, id: itemIdentifier)
            }
        )
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            self?.supplementaryViewProvider(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        
        homeworkCollectionView.dataSource = dataSource
        
        
        view.addSubview(homeworkCollectionView)
        
        homeworkCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureCreateButton() {
        
        createHomeworkButton.rx.tap.subscribe { [coordinator] _ in
            coordinator?.goToCreate()
        }.disposed(by: disposeBag)
        
        view.addSubview(createHomeworkButton)
        
        createHomeworkButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(createHomeworkButton.snp.width)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-25)
            make.trailing.equalToSuperview().offset(-25)
        }
    }
    
    private func configureEmptyStateLabel() {
        
        view.addSubview(emptyStateLabel)
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension HomeworkViewController {
    
    func cellProvider(collectionView: UICollectionView, indexPath: IndexPath, id: Int64) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeworkCollectionViewCell.identifier,
            for: indexPath
        ) as! HomeworkCollectionViewCell
        
        let homework = viewModel.homework(with: id)
        cell.homework = homework
        
        cell.didMarkedDone = { [weak self] in
            self?.viewModel.markDone(with: id)
        }
        
        cell.didDeleted = { [weak self] in
            self?.viewModel.deleteHomework(with: id)
        }
        
        
        return cell
    }
    
    func supplementaryViewProvider(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier:
                    HomeworkSectionHeader.identifier,
                for: indexPath
            ) as! HomeworkSectionHeader
            
            sectionHeader.title = headerTitle(in: indexPath)
            
            return sectionHeader
            
        } else {
            return UICollectionReusableView()
        }
    }
}

extension HomeworkViewController {
    
    private func listenState() {
        
        viewModel.homeworkPublisher
            .sink { [dataSource, emptyStateLabel, homeworkCollectionView] newHomework in
                var snapshot = NSDiffableDataSourceSnapshot<String, Int64>()
                
                snapshot.appendSections(newHomework.map { $0.subject.name })
                
                newHomework.forEach { subject in
                    snapshot.appendItems(subject.homeworks.map { $0.id }, toSection: subject.subject.name)
                }
                
                snapshot.reloadItems(snapshot.itemIdentifiers)
                snapshot.reloadSections(snapshot.sectionIdentifiers)
                
                UIView.animate(withDuration: 0.2) {
                    dataSource?.apply(snapshot)
                }
                
                UIView.transition(with: emptyStateLabel, duration: 0.2) {
                    emptyStateLabel.isHidden = !newHomework.isEmpty
                }
                
                homeworkCollectionView.isScrollEnabled = !newHomework.isEmpty
                
            }
            .store(in: &bag)
    }
}

extension HomeworkViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let homework = homework(in: indexPath)
        guard let homework = homework else { return }
        
        coordinator?.goToDetails(of: homework)
    }
    
    private func homework(in indexPath: IndexPath) -> HomeworkEntity? {
        let id = dataSource.itemIdentifier(for: indexPath)
        guard let id = id else { return nil }
        return viewModel.homework(with: id)
    }
    
    private func headerTitle(in indexPath: IndexPath) -> String? {
        return dataSource.snapshot().sectionIdentifiers[indexPath.section]
    }
}

extension HomeworkViewController {
    
    private func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        
        let edgeInsets: CGFloat = 20
        let itemSpacing: CGFloat = 5
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: itemSpacing, bottom: 0, trailing: itemSpacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(view.frame.width - edgeInsets - edgeInsets),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize (
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: edgeInsets, bottom: 0, trailing: edgeInsets)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

@available(iOS 17.0, *)
#Preview {
    let vc = HomeworkViewController()
    vc.viewModel = HomeworkViewModelMock()
    
    return UINavigationController(rootViewController: vc)
    
}
