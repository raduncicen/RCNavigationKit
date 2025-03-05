//
//  RCBaseCoordinator.swift
//  CoordinatorExample
//
//  Created by Radun Çiçen on 1.03.2025.
//

import SwiftUI

class RCBaseCoordinator: RCCoordinatorWithChildren, CoordinatorDelegateTypeProtocol {
    typealias CoordinatorDelegateType = RCCoordinatorDelegate
    
    var parent: (any RCCoordinatorDelegate)?

    let navigationController: UINavigationController
    var childCoordinators: [any RCCoordinatorWithChildren] = []

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }


}

