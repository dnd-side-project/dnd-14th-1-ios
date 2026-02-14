//
//  Coordinator.swift
//  dnd-14th-1-iOS
//
//  Created by a on 2/14/26.
//

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}
