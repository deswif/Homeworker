//
//  HomeworkCollectionViewCell.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit
import Combine

class HomeworkCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeworkCollectionViewCell"
    
    private var bag = Set<AnyCancellable>()
    
    var didDeleted: (() -> Void)?
    var didMarkedDone: (() -> Void)?
    
    private var futureAction: (() -> Void)?
    
    var homework: HomeworkEntity? {
        willSet {
            if let homework = newValue {
                applyHomework(homework: homework)
            }
        }
    }
    
    private let titleView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.lineBreakMode = .byTruncatingTail
        view.font = .systemFont(ofSize: 19, weight: .semibold)
        view.textColor = .label
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        didDeleted = nil
        didMarkedDone = nil
        homework = nil
        futureAction = nil
    }
    
    private func configureViews() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        
        let interaction = UIContextMenuInteraction(delegate: self)
        addInteraction(interaction)
        
        contentView.addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(8)
            make.trailing.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    private func applyHomework(homework: HomeworkEntity) {
        backgroundColor = homework.status == .done ? .systemGreen : .systemGray6
        titleView.textColor = homework.status == .done ? .black : .label
        
        let attributeString = NSMutableAttributedString(string: homework.title)
        
        if homework.status == .done {
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 1,
                range: NSRange(location: 0, length: attributeString.length)
            )
        }
        
        titleView.attributedText = attributeString
    }
}

extension HomeworkCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        var actions: [UIAction] = []
        
        if let didMarkedDone = didMarkedDone, let homework = homework, homework.status != .done {
            actions.append(UIAction(title: "Done", image: UIImage(systemName: "checkmark.circle")) { [weak self] action in
                self?.futureAction = didMarkedDone
            })
        }
        
        if let didDeleted = didDeleted {
            actions.append(UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
                self?.futureAction = didDeleted
            })
        }
        
        if actions.isEmpty { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { recomendedActions in
            UIMenu(children: actions)
        })
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) { [weak self] in
            self?.futureAction?()
            self?.futureAction = nil
        }
    }
}
