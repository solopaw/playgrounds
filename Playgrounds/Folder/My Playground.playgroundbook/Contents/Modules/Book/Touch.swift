//
//  Touch.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit

/// A structure that holds information about when you touch and drag across the scene.
///
/// - localizationKey: Touch
public struct Touch {
    
    /// The position of this touch on the scene.
    ///
    /// - localizationKey: Touch.position
    public var position: Point
    
    /// The distance of this touch from the previous object that was placed on the scene.
    ///
    /// - localizationKey: Touch.previousPlaceDistance
    public var previousPlaceDistance: Double

    /// The number of graphics that were placed on the scene during this touch event.
    ///
    /// - localizationKey: Touch.numberOfObjectsPlaced
    public var numberOfObjectsPlaced: Int
    
    
    var touchedGraphic: Graphic?
    
    public static func ==(lhs: Touch, rhs: Touch) -> Bool {
        return lhs.position == rhs.position &&
                lhs.previousPlaceDistance == rhs.previousPlaceDistance &&
                lhs.numberOfObjectsPlaced == rhs.numberOfObjectsPlaced
    }

}
 
