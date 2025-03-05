//
//  RCCoordinator.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//

import SwiftUI


public enum RCCoordinatorRootPresentationStyle {
    case push
    case present(_ modalPresentationStyle: UIModalPresentationStyle)
}

public protocol RCCoordinator: AnyObject {
    var navigationController: UINavigationController { get }
}

// MARK: - NAVIGATION EXTENSIONS

public extension RCCoordinator {
    var identifier: String? {
        self.rootViewControllerIdentifier
    }

    func matchCoordinatorIdWithRootViewController(_ viewController: UIViewController) {
        let rootId = UUID().uuidString
        viewController.identifier = rootId
        rootViewControllerIdentifier = viewController.identifier
    }
}

public extension RCCoordinator {

    func presentAsRoot<Content: View>(
        _ viewController: RCHostingController<Content>,
        style: RCCoordinatorRootPresentationStyle = .push,
        popUpTo identifier: String? = nil,
        animated: Bool = true
    ) {
        presentAsRootLogic(
            viewController,
            style: style,
            popUpTo: identifier,
            animated: animated
        )
    }

    func popFlow(animated: Bool = true) {
        guard let identifier else {
            assertionFailure("Coordinator has no assigned rootViewControllerIdentifier")
            return
        }
        // Remove this coordinator from its parent
        if let self = self as? (any RCCoordinatorWithChildren) {
            self.parent?.removeChildCoordinator(with: identifier)
        }

        if let coordinator = self as? RCModallyPresentableCoordinator {
            guard coordinator.localNavigationController?.identifier == identifier else {
                assertionFailure("Coordinator's localNavigationController does not match coordinator's rootViewControllerIdentifier")
                navigationController.popViewControllers(upTo: identifier, animated: animated)
                navigationController.dismiss(animated: animated)
                return
            }
            // CASE: Has a localNavigationController as root of the coordinator
            navigationController.dismiss(animated: animated)
        } else if let presentedVC = navigationController.presentedViewController, presentedVC.identifier == identifier {
            // CASE: Has a presentedViewController (probably a success or information view) as the root of the coordinator.
            navigationController.dismiss(animated: animated)
        } else {
            // CASE: Has a default pushed root viewController as the root of the coordinator
            navigationController.popViewControllers(upTo: identifier, animated: animated)
        }
    }
}

extension RCCoordinator {
    internal func presentAsRootLogic<Content: View>(
        _ viewController: RCHostingController<Content>,
        style: RCCoordinatorRootPresentationStyle = .push,
        popUpTo identifier: String? = nil,
        animated: Bool = true
    ) {
        viewController.isCoordinatorRoot = true

        let identifier = identifier ?? self.identifier
        // If The the coordinator already has a root
        if let identifier {
            navigationController.setNavigationStack(
                upTo: identifier,
                include: true,
                adding: viewController,
                animated: animated,
                completion: nil
            )
            matchCoordinatorIdWithRootViewController(viewController)
            return
        }

        // If Coordinator just initialized
        switch style {
        case .push:
            matchCoordinatorIdWithRootViewController(viewController)
            navigationController.pushViewController(viewController, animated: animated)
        case .present(let modalPresentationStyle):
            if let coordinator = self as? RCModallyPresentableCoordinator {
                coordinator.startAsModalWithLocalNavigationController(
                    viewController: viewController,
                    modalPresentationStyle: modalPresentationStyle,
                    animated: animated
                )
                return
            }

            let embedInNavigationController = UINavigationController(rootViewController: viewController)
            matchCoordinatorIdWithRootViewController(embedInNavigationController) // FIXME: BURAYI KONTROL ETMELISIN
            navigationController.present(viewController, animated: animated)
        }
    }

}
