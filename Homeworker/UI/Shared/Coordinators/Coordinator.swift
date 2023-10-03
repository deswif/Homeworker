//
//  Coordinator.swift
//  Homeworker
//
//  Created by Max Steshkin on 03.10.2023.
//

import Foundation

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get }
    
    func start()
}
