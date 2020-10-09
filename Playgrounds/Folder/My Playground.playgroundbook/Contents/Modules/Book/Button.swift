//
//  Button.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit

/// A button that can execute your code when pressed.
///
/// - localizationKey: Button
public class Button {
    
    /// The display name of the button.
    ///
    /// - localizationKey: Button.name
    public var name: String
    
    /// The function that’s called when you press the button.
    ///
    /// - localizationKey: Button.onPress
    public var onPress: (() -> Void)?

    /// Creates a button with a name and an optional, one-character emoji icon.
    ///
    /// - Parameter name: The name that will be displayed on the button.
    ///
    /// - localizationKey: Button(name:)
    public init(name:  String) {
        self.name = name        
    }

}
