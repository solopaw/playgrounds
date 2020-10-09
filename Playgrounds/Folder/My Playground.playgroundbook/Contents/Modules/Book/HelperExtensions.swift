//
//  HelperExtensions.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

public extension String {

    /// Splits the string into its component characters and returns them as an array of String.
    ///
    /// - localizationKey: String.componentsByCharacter()
    func componentsByCharacter() -> [String] {
        return self.map( { String($0) } )
    }
    
    /// Returns a random composed character sequence as a String.
    ///
    /// - localizationKey: String.randomCharacter
    var randomCharacter: String {
        guard let character = self.randomElement() else { return "" }
        return String(character)
    }
    
    /// Returns the string with any whitespace characters removed.
    ///
    /// - localizationKey: String.withoutWhitespace
    var withoutWhitespace: String {
        let separatedComponents = self.components(separatedBy: .whitespaces)
        return separatedComponents.joined()
    }
}

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }
    
    func clamped(min: Int, max: Int) -> Int {
        return Swift.max(min, Swift.min(max, self))
    }
}

extension Point {
    
    /// Returns the distance from another point.
    ///
    /// - Parameter from: The point from which to measure distance.
    ///
    /// - localizationKey: Point.distance(from:)
    public func distance(from: Point) -> Double {
        
        let distanceVector = Point(x: from.x - self.x, y: from.y - self.y)
        return Double(sqrt(Double(distanceVector.x * distanceVector.x) + Double(distanceVector.y * distanceVector.y)))
    }
}

// In this app we are clamping the values the user can enter to a defined range to be more approachable. This extension is used to apply it consistently across the app.
extension ClampedInteger {
    init(clampedUserValueWithDefaultOf integer: Int) {
        self.init(integer, in: Constants.userValueRange)
    }
}

public extension Array {

    /// A randomly chosen index into the array.
    ///
    /// - localizationKey: Array.randomIndex
    var randomIndex: Int {
        return Int.random(in: 0..<self.count)
    }
    
    /// A randomly chosen item from the array.
    ///
    /// - localizationKey: Array.randomItem
    var randomItem: Element {
        return self[self.randomIndex]
    }
}

struct Constants {
    static let userValueRange: ClosedRange<Int> = 0...100
    
    static var maxUserValue: Int {
        return userValueRange.upperBound
    }
}

public extension UIImage {

    func resized(to size: CGSize, scale: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage ?? self
    }

}

extension CGSize {
    
    /// Returns a size that fits within the given size, while preserving this size’s aspect ratio.
    ///
    /// - Parameter within: The size within which the size must fit.
    ///
    /// - localizationKey: CGSize.fit(within:)
    public func fit(within: CGSize) -> CGSize  {
        
        let ratio = width > height ?  (height / width) : (width / height)
        
        if width >= height {
            return CGSize(width: within.width, height: within.width * ratio)
        }
        else {
            return CGSize(width: within.height * ratio, height: within.height)
        }
    }
}


extension UIColor {
    
    var redComponent: CGFloat {
        var component = CGFloat()
        getRed(&component, green: nil, blue: nil, alpha: nil)
        return component
    }

    var greenComponent: CGFloat {
        var component = CGFloat()
        getRed(nil, green: &component, blue: nil, alpha: nil)
        return component
    }
    
    var blueComponent: CGFloat {
        var component = CGFloat()
        getRed(nil, green: nil, blue: &component, alpha: nil)
        return component
    }
    
    var alphaComponent: CGFloat {
        var component = CGFloat()
        getRed(nil, green: nil, blue: nil, alpha: &component)
        return component
    }

}


extension SKScene {
    var center: CGPoint { return CGPoint(x: size.width / 2, y: size.height / 2) }
}
