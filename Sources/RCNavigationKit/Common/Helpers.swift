//
//  Helpers.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 25.02.2025.
//
import Foundation

public struct Helpers {
    public static var isSwiftUIPreview: Bool = {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }()
}
