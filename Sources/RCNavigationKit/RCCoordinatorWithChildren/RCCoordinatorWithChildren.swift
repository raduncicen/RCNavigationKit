//
//  RCCoordinatorWithChilds.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 28.02.2025.
//

import SwiftUI


public protocol RCCoordinatorWithChildren: RCCoordinator {
    var childCoordinators: [RCCoordinatorWithChildren] { get set }
    var parent: RCCoordinatorDelegate? { get set }

    init(navigationController: UINavigationController)
//    func start(popUpTo identifier: String?)
}

extension RCCoordinatorWithChildren {
    public func presentAsRoot<Content>(
        _ viewController: RCHostingController<Content>,
        style: RCCoordinatorRootPresentationStyle = .push,
        popUpTo identifier: String? = nil,
        animated: Bool = true
    ) where Content : View {
        // Make sure the parent is set and force it in DEV environment
        if !Helpers.isSwiftUIPreview {
            guard parent != nil else {
                assertionFailure("Coordinator must have a parent")
                return
            }
        }

        presentAsRootLogic(viewController, style: style, popUpTo: identifier, animated: animated)
    }
}


// MARK: - CHILD COORDINATOR CRUD ACTIONS

public extension RCCoordinatorWithChildren {

    // MARK: - Insert and Start Child functions
    func insertChild(_ childCoordinator: RCCoordinatorWithChildren) {
        guard let parent = self as? RCCoordinatorDelegate else {
            assertionFailure("Coordinator should conform to respective NavDelegate for the ChildCoordinator")
            return
        }

        childCoordinator.parent = parent
        childCoordinators.append(childCoordinator)
    }

    // MARK: - Remove Child Coordinator

    @discardableResult
    func removeChild(id rootViewControllerIdentifier: String?) -> RCCoordinator? {
        guard let rootViewControllerIdentifier, let index = childCoordinators.lastIndex(where: { $0.rootViewControllerIdentifier == rootViewControllerIdentifier }) else {
            return nil
        }
        let removedChild = childCoordinators.remove(at: index)
        //        devLog("CHILD_COORDINATOR_REMOVED: Parent:\(self) - Child: \(removedChild.self)")
        return removedChild
    }

    @discardableResult
    func popLastChild() -> (any RCCoordinator)? {
        let removedChild = childCoordinators.popLast()
        //        devLog("CHILD_COORDINATOR_REMOVED: Parent:\(self) - Child: \(String(describing: removedChild.self))")
        return removedChild
    }

    func resetChilds() {
        //        devLog("CHILD_COORDINATOR_REMOVED: Parent:\(self) - Removed All Childs (Count: \(childCoordinators.count))")
        childCoordinators = []
    }
}

