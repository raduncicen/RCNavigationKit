//
//  RCAttributedStringBuilder.swift
//  RCNavigationKit
//
//  Created by Radun Çiçen on 3.03.2025.
//

import UIKit

/// Builder for creating an attributed string with various styles.
public class RCAttributedStringBuilder {
    private var baseString: String
    private var attributedString: NSMutableAttributedString
    private var currentSubstring: String?  // Keeps track of the active substring for modifications

    public init(_ text: String) {
        self.baseString = text
        self.attributedString = NSMutableAttributedString(string: text)
    }

    /// Set the substring to work on. If nil, applies to the entire text.
    @discardableResult
    public func setSubstring(_ substring: String?) -> Self {
        self.currentSubstring = substring
        return self
    }

    /// Apply attributes (textColor, font, underlineColor, link) to the selected substring or full text.
    @discardableResult
    public func apply(
        textColor: UIColor? = nil,
        font: UIFont? = nil,
        underlineColor: UIColor? = nil,
        link: String? = nil
    ) -> Self {
        var attributes: [NSAttributedString.Key: Any] = [:]

        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        if let font = font {
            attributes[.font] = font
        }
        if let underlineColor = underlineColor {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            attributes[.underlineColor] = underlineColor
        }
        if let link = link {
            attributes[.link] = link
        }

        let targetSubstring = currentSubstring ?? baseString
        let range = (baseString as NSString).range(of: targetSubstring)

        if range.location != NSNotFound {
            attributedString.addAttributes(attributes, range: range)
        }

        return self
    }

    /// Build and return the final `AttributedString` (Swift 5.5+).
    public func build() -> AttributedString {
        return AttributedString(attributedString)
    }

    /// Build and return the final `NSMutableAttributedString`.
    public func buildMutable() -> NSMutableAttributedString {
        return attributedString
    }
}


import SwiftUI

#Preview {
    let builder = RCAttributedStringBuilder("Ismail inanilmaz bir developer")
        .apply(textColor: .brown, font: .systemFont(ofSize: 18, weight: .regular))
        .setSubstring("Ismail")
        .apply(
            textColor: .blue,
            font: .systemFont(ofSize: 40, weight: .bold),
            underlineColor: .red
        )
        .apply(link: "www.google.com")
        

    Text(builder.build())
        .environment(\.openURL, OpenURLAction { url in
            print(url.absoluteString)
            return .handled
        })
}
