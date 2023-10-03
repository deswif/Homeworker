//
//  CustomButton.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import UIKit

class CustomButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
                
                if let isEnabled = self?.isEnabled {
                    self?.alpha = isEnabled ? 1 : 0.5
                }
            }
        }
    }

    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addTarget(self, action: #selector(pressDown), for: [.touchDown, .touchDragEnter, .editingDidBegin])
        addTarget(self, action: #selector(pressEnd), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit, .editingDidEnd])
    }
    
    @objc private func pressDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
            self?.alpha = 0.5
        }
    }
    
    @objc private func pressEnd() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .curveEaseInOut]) { [weak self] in
            self?.alpha = 1
        }
    }

}
