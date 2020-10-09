//
//  Graphic.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import PlaygroundSupport
import SpriteKit

/*
    The Graphic class implements the user process’s implementation of the Graphic protocol.
    It works by sending messages to the live view when appropriate, where the real actions are enacted.
    It is a proxy, that causes its remote counterpart to invoke actions that affect the live view.
 */

/// A graphic object, made from an image or string, that can be placed on the scene.
///
/// - localizationKey: Graphic
public class Graphic: MessageControl {
    
    let id: String
    
    let defaultAnimationTime = 0.5
    
    var suppressMessageSending: Bool = false
    
    /// The font used to render the text.
    ///
    /// - localizationKey: Graphic.fontName
    public var fontName: FontName = .avenirNext {
       
        didSet {
            guard !suppressMessageSending else { return }
            Message.setFontName(id: id, name: fontName.rawValue).send()
        }
    }
    
    /// How big the text is.
    ///
    /// - localizationKey: Graphic.fontSize
    public var fontSize: Number = 32  {
       
        didSet {
            guard !suppressMessageSending else { return }
            Message.setFontSize(id: id, size: fontSize.int).send()
        }
    }
    
    /// The text (if any) that’s displayed by the graphic. Setting a new text updates the display.
    ///
    /// - localizationKey: Graphic.text
    public var text: String = "" {
       
        didSet {
            guard !suppressMessageSending else { return }
            Message.setText(id: id, text: text).send()
        }
    }
    

    /// The color for the text of the graphic.
    ///
    /// - localizationKey: Graphic.textColor
    public var textColor: Color = .black {
      
        didSet {
            guard !suppressMessageSending else { return }
            let color = textColor
            Message.setTextColor(id: id, color: color).send()
        }
    }
    
    
    init() {
        id = UUID().uuidString
        Message.createNode(id: id).send()
    }
    
    
    /// Creates a graphic with the given identifier (e.g. reconstructing a graphic).
    ///
    /// - Parameter id: The identifier associated with the graphic.
    ///
    /// - localizationKey: Graphic(id:)
    public required init(id: String) {
        
        self.id = id
    }

    convenience init(named: String) {
       
        self.init(image: Image(imageLiteralResourceName: named)) // We  need an id generated
        
    }
    
        
    /// Creates a graphic from the given image.
    ///
    /// - Parameter image: The image with which to create the graphic.
    ///
    /// - localizationKey: Graphic(image:)
    public convenience init(image: Image) {
      
        self.init() //call no-arg initializer on self so that we get an id.
        self.image = image
        /*
            Manually sending a message here, as setting a property on a struct
            from within one of it’s own initializers will not trigger the didSet property.
        */
        Message.setImage(id: id, image: image).send()
    }
    
    
    /// Creates a graphic from the given text.
    ///
    /// - Parameter text: The text with which to create the graphic.
    ///
    /// - localizationKey: Graphic(text:)
    public convenience init(text: String) {
       
        self.init() //call no-arg initializer on self so that we get an id.
        textColor = .white
        self.text = text
        Message.setFontSize(id: id, size: fontSize.int).send()
        Message.setFontName(id: id, name: fontName.rawValue).send()
        Message.setTextColor(id: id, color: textColor).send()
        Message.setText(id: id, text: text).send()
    }
    
       
    func send(_ action: SKAction, withKey: String? = nil) {
       
        guard !suppressMessageSending else { return }
        Message.runAction(id: id, action: action, key: withKey).send()
    }
    
    var isHidden: Bool = false {
      
        didSet {
            
            guard !suppressMessageSending else { return }
            if isHidden {
                send(.hide(), withKey: "hide")
            }
            else {
                send(.unhide(), withKey: "unhide")
            }
        }
    }
    
    /// How transparent the graphic is—from 0.0 (totally transparent) to 1.0 (totally opaque).
    ///
    /// - localizationKey: Graphic.alpha
    public var alpha: Number = 1.0 {
       
        didSet {
            guard !suppressMessageSending else { return }
            send(.fadeAlpha(to: CGFloat(alpha.double), duration: 0), withKey: "fadeAlpha")
            assessmentController?.append(.setAlpha(graphic: self, alpha: alpha.double))
        }
    }
    
    
    /// The angle, in degrees, to rotate the graphic. Changing the angle rotates the graphic counterclockwise around its center. A value of 0.0 (the default) means no rotation. A value of 180 rotates the object 180° and flips it.
    ///
    /// - localizationKey: Graphic.rotation
    public var rotation: Number {
        get {
            return Double(rotationRadians / CGFloat.pi) * 180.0
        }
        set(newRotation) {
            rotationRadians = (CGFloat(newRotation.double) / 180.0) * CGFloat.pi
        }
    }
    
    // Internal only representation of the rotation in radians.
    var rotationRadians: CGFloat = 0 {
       
        didSet {
            
            guard !suppressMessageSending else { return }
            send(.rotate(toAngle: rotationRadians, duration: defaultAnimationTime, shortestUnitArc: false), withKey: "rotateTo")
        }
    }
    
    /// The position that the center of the graphic is placed at.
    ///
    /// - localizationKey: Graphic.position
    public var position: Point = Point(x: 0, y: 0) {
        
        didSet {
            
            guard !suppressMessageSending else { return }
            send(.move(to: CGPoint(position), duration: 0), withKey: "moveTo")
        }
    }
    
    
    /// Moves the graphic to a position animated over duration in seconds.
    ///
    /// - Parameter to: The point to move to.
    /// - Parameter duration: The time over which to move.
    ///
    /// - localizationKey: Graphic.move(to:duration:)
    public func move(to: Point, duration: Number = 0.0) {
        
        let moveAction = SKAction.move(to: CGPoint(to), duration: duration.double)
        moveAction.timingMode = .easeInEaseOut
       send(moveAction, withKey: "moveTo")
        assessmentController?.append(.moveTo(graphic: self, position: to))
    }
    
    /// Moves the graphic by x, y, animated over duration in seconds.
    ///
    /// - Parameter x: The distance to move along the x-axis.
    /// - Parameter y: The distance to move along the y-axis.
    /// - Parameter duration: The time over which to move.
    ///
    /// - localizationKey: Graphic.moveBy(x:y:duration:)
    public func moveBy(x: Number, y: Number, duration: Number = 0.0) {
       
        let vector = CGVector(dx: CGFloat(x.double), dy: CGFloat(y.double))
        let moveAction = SKAction.move(by: vector, duration: duration.double)
        moveAction.timingMode = .easeInEaseOut
        send(moveAction, withKey: "moveBy")
    }
    
    /// The scale of the graphic’s size, where 1.0 is normal, 0.5 is half the normal size, and 2.0 is twice the normal size.
    ///
    /// - localizationKey: Graphic.scale
    public var scale: Number  = 1.0 {
        
        didSet {
            
            guard !suppressMessageSending else { return }
            send(.scale(to: CGFloat(scale.double), duration: defaultAnimationTime), withKey: "scaleTo")
        }
    }
    
    /// Scales the graphic over duration in seconds.
    ///
    /// - Parameter to: The scale to change to.
    /// - Parameter duration: The time over which to change scale.
    ///
    /// - localizationKey: Graphic.scale(to:duration:)
    public func scale(to: Number, duration: Number = 0.0) {
        
        guard !suppressMessageSending else { return }
        let scaleAction = SKAction.scale(to: CGFloat(to.double), duration: duration.double)
        scaleAction.timingMode = .easeInEaseOut
        send(scaleAction, withKey: "scaleTo")
    }
    
    /// The image being displayed by the graphic.
    ///
    /// - localizationKey: Graphic.image
    public var image: Image? = nil {
        didSet {
            
            guard !suppressMessageSending else { return }
            Message.setImage(id: id, image: image).send()
        }
    }

    /// Removes the graphic from the scene.
    ///
    /// - localizationKey: Graphic.remove()
    public func remove() {
        
        Message.removeGraphic(id: id).send()
        assessmentController?.append(.remove(graphic: self))
    }
    
    /// Moves the graphic around the center point in an elliptical orbit. The direction of rotation is chosen at random.
    ///
    /// - Parameter x: The distance of the orbital path from the center along the x-axis.
    /// - Parameter y: The distance of the orbital path from the center along the y-axis.
    /// - Parameter period: The period of the orbit in seconds.
    ///
    /// - localizationKey: Graphic.orbit(x:y:period:)
    public func orbit(x: Number, y: Number, period: Number = 4.0) {
        let orbitAction = SKAction.orbitAction(x: CGFloat(x.double), y: CGFloat(y.double), period: period.double)
        send(orbitAction, withKey: "orbit")
        assessmentController?.append(.orbit(graphic: self, x: x.double, y: y.double, period: period.double))

    }
    
    /// Rotates the graphic continuously, with a given period of rotation.
    ///
    /// - Parameter period: The period of each rotation in seconds.
    ///
    /// - localizationKey: Graphic.spin(period:)
    public func spin(period: Double = 2.0) {
        
        Message.runAction(id: id, action: .spin(period: period), key: "spin").send()
        assessmentController?.append(.spin(graphic: self, period: period.double))
    }
    
    /// Pulsates the graphic by increasing and decreasing its scale a given number of times, or indefinitely.
    ///
    /// - Parameter period: The period of each pulsation in seconds.
    /// - Parameter count: The number of pulsations. The default (-1) is to pulsate indefinitely.
    ///
    /// - localizationKey: Graphic.pulsate(period:count:)
    public func pulsate(period: Number = 5.0, count: Number = -1) {
        send(.pulsate(period: period.double, count: count.int), withKey: "pulsate")
        assessmentController?.append(.pulsate(graphic: self, period: period.double, count: count.int))
    }

    /// Animates the graphic to fade out over the given number of seconds.
    ///
    /// - Parameter after: The time in seconds to fade out the graphic.
    ///
    /// - localizationKey: Graphic.fadeOut(after:)
    public func fadeOut(after seconds: Number) {
        Message.runAction(id: id, action: .fadeOut(withDuration: seconds.double), key: "fadeOut").send()
        
    }
    
    /// Animates the graphic to fade in over the given number of seconds.
    ///
    /// - Parameter after: The time in seconds to fade in the graphic.
    ///
    /// - localizationKey: Graphic.fadeIn(after:)
    public func fadeIn(after seconds: Number) {
        Message.runAction(id: id, action: .fadeIn(withDuration: seconds.double), key: "fadeIn").send()
        
    }
    
    /// Animates the graphic by shaking it for the given number of seconds.
    ///
    /// - Parameter duration: The time in seconds to shake the graphic.
    ///
    /// - localizationKey: Graphic.shake(duration:)
    public func shake(duration: Number = 2.0) {

        Message.runAction(id: id, action: .shake(duration: duration.double), key: "shake").send()
    }

    /// Animates the graphic by swelling it up and spinning it for the given number of seconds, before playing a pop sound and removing it from the scene.
    ///
    /// - Parameter after: The time in seconds to spin the graphic before popping and removing it.
    ///
    /// - localizationKey: Graphic.spinAndPop(after:)
    public func spinAndPop(after seconds: Number = 2.0) {
        Message.spinAndPop(id: id, after: seconds.double).send()
        assessmentController?.append(.spinAndPop(graphic: self, after: seconds))
    }
    
    /// Animates the graphic using a swirling motion with several rotations over the given number of seconds, before removing it from the scene.
    ///
    /// - Parameter after: The time in seconds to swirl the graphic before removing it.
    ///
    /// - localizationKey: Graphic.swirlAway(after:)
    public func swirlAway(after seconds: Number = 2.0) {
       Message.swirlAway(id: id, after: seconds.double, rotations: 4.0).send()
        assessmentController?.append(.swirlAway(graphic: self, after: seconds))
    }
    
    /// Animates the graphic to a new position over duration in seconds, before playing a warp sound and removing it from the scene.
    ///
    /// - Parameter to: The point to move to.
    /// - Parameter duration: The time over which to move the graphic before removing it.
    ///
    /// - localizationKey: Graphic.moveAndZap(to:duration:)
    public func moveAndZap(to position: Point, duration: Number = 0.25) {
        Message.moveAndRemove(id: id, position: CGPoint(position), duration: duration.double, sound: .warp).send()
        assessmentController?.append(.moveAndZap(graphic: self, position: position))
    }
    
    /// Animates the graphic to a new position over duration in seconds, before removing it from the scene.
    ///
    /// - Parameter to: The point to move to.
    /// - Parameter duration: The time over which to move the graphic before removing it.
    ///
    /// - localizationKey: Graphic.moveAndRemove(to:duration:)
    public func moveAndRemove(to position: Point, duration: Number = 0.25) {
        Message.moveAndRemove(id: id, position: CGPoint(position), duration: duration.double, sound: nil).send()
        assessmentController?.append(.moveAndRemove(graphic: self, position: position))
    }
    
    /// The distance of the graphic from the given point.
    ///
    /// - Parameter from: The point from which to measure distance.
    ///
    /// - localizationKey: Graphic.distance(from:)
    public func distance(from: Point) -> Number {
        
        return position.distance(from: from)
        
    }
    
    // MARK: Unavailable
    
    @available(*, unavailable, message: "You need to add the 'text:' label when creating a graphic with a string. For example:\n\nlet graphic = Graphic(text: \"My string\")")
    public convenience init(_ text: String) { self.init() }
    
    @available(*, unavailable, message: "You need to add the 'image:' label when creating a graphic with an image. For example:\n\nlet graphic = Graphic(image: myImage)")
    public convenience init(_ image: Image) { self.init() }

}


extension Graphic: Hashable, Equatable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    public static func ==(lhs: Graphic, rhs: Graphic) -> Bool {
        
        return lhs.id == rhs.id
    }
    
}



