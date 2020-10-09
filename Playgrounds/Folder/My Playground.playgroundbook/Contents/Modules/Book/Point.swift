//
//  Point.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import CoreGraphics

/// Specifies a point in the scene with x and y coordinates.
/// - localizationKey: Point
public struct Point {
    
    /// The x coordinate for the point.
    ///
    /// - localizationKey: Point.x
    public var x: Double
    
    /// The y coordinate for the point.
    ///
    /// - localizationKey: Point.y
    public var y: Double
    
    /// Creates a point with x and y coordinates.
    ///
    /// - Parameter x: The position of the point along the x-axis.
    /// - Parameter y: The position of the point along the y-axis.
    ///
    /// - localizationKey: Point(x{Double}:y{Double}:)
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Point {
    /// Creates a point with x and y coordinates.
    ///
    /// - Parameter x: The position of the point along the x-axis.
    /// - Parameter y: The position of the point along the y-axis.
    ///
    /// - localizationKey: Point(x{Number}:y{Number}:)
    public init(x: Number, y: Number) {
        self.x = x.double
        self.y = y.double
    }
    
    /// Creates a point with x and y coordinates.
    ///
    /// - Parameter x: The position of the point along the x-axis.
    /// - Parameter y: The position of the point along the y-axis.
    ///
    /// - localizationKey: Point(x{Int}:y{Int}:)
    public init(x: Int, y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }

    /// Creates a point with a CGPoint.
    ///
    /// - Parameter point: The CGPoint to make a point.
    ///
    /// - localizationKey: Point(_:)
    public init(_ point: CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }
}

extension Point: Hashable, Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }

    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}


extension CGPoint {
    public init(_ point: Point) {
        self.init()
        self.x = CGFloat(point.x)
        self.y = CGFloat(point.y)
    }
}
