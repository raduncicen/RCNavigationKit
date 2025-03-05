//
//  CoordinatorDelegateTypeProtocol.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 1.03.2025.
//
import Foundation

class WeakObjectWrapper<T: AnyObject> {
    weak var value: T?
    init(value: T?) {
        self.value = value
    }
}

public protocol CoordinatorDelegateTypeProtocol: AnyObject, Parentable {
    associatedtype CoordinatorDelegateType
}


private var parentKey: UInt8 = 0

extension CoordinatorDelegateTypeProtocol where CoordinatorDelegateType: AnyObject {
    var _parent: CoordinatorDelegateType? {
        get {
            let wrapper = objc_getAssociatedObject(self, &parentKey) as? WeakObjectWrapper<CoordinatorDelegateType>
            return wrapper?.value
        }
        set {
            let wrapper = WeakObjectWrapper(value: newValue)
            objc_setAssociatedObject(self, &parentKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var parent: RCCoordinatorDelegate? {
        get { _parent as? RCCoordinatorDelegate }
        set { setParent(newValue) }
    }

    public func setParent(_ newValue: RCCoordinatorDelegate?) {
        guard newValue != nil else {
            _parent = nil
            return
        }
        guard let newValue = newValue as? CoordinatorDelegateType else {
            assertionFailure("In correct navDelegate type.")
            return
        }
        _parent = newValue
    }
}
