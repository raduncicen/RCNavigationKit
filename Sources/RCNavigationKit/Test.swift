//
//  Test.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 1.03.2025.
//
import Combine
import SwiftUI

protocol GameCoordinatorDelegate: RCCoordinatorDelegate {}

protocol GameCoordinator: RCCoordinatorWithChildren {}

class GameCoordinatorImpl: GameCoordinator {
    var parent: (any RCCoordinatorDelegate)?
    
    typealias CoordinatorDelegateType = GameCoordinatorDelegate

    let navigationController: UINavigationController
    var childCoordinators: [any RCCoordinatorWithChildren] = []

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(popUpTo identifier: String?) {

    }

    func navigate() {
        navigationSubject.send(.addVehicle(.start))
    }
}


let navigationSubject: PassthroughSubject<NavigationPaths, Never> = .init()

class RCNavigator {
    func navigate() {
        navigationSubject.send(.addVehicle(.start))
    }
}

protocol NavigationAction {

}

enum NavigationPaths {
    enum Start {
        case addVehicle
    }

    case addVehicle(AddVehicle)
    case createOrder(CreateOrder)
    case orders(Orders)

    enum AddVehicle {
        case start
        case finish
    }

    enum CreateOrder {
        case start
        case summary
        case finish
    }

    enum Orders {
        case start
        case finish
    }
}
