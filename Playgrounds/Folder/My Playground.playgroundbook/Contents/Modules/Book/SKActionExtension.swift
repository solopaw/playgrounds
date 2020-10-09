//
//  SKActionExtension.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import SpriteKit


extension SKAction {
    
    /// Creates an action that moves a node around the center point in an elliptical orbit. The direction of rotation is chosen at random.
    ///
    /// - Parameter x: The distance of the orbital path from the origin along the x-axis.
    /// - Parameter y: The distance of the orbital path from the origin along the y-axis.
    /// - Parameter period: The period of the orbit in seconds.
    ///
    /// - localizationKey: SKAction.orbitAction(x:y:period)
    public class func orbitAction(x: CGFloat, y: CGFloat, period: Double = 4.0) -> SKAction {
        // x, y
        let center = CGPoint(x: 0, y: 0)
        let rect = CGRect(x: center.x - x, y: center.y - y, width: x * 2.0, height: y * 2.0)
        let ovalPath = UIBezierPath(ovalIn: rect)
        let reversed = randomInt(from: 0, to: 1) == 1
        
        var orbitAction = SKAction.follow(ovalPath.cgPath,
                                          asOffset: false ,
                                          orientToPath: true,
                                          duration: period)
        if reversed {
            orbitAction = orbitAction.reversed()
        }
        
        return .repeatForever(orbitAction)
    }

    /// Creates an action that pulsates a node by increasing and decreasing its scale a given number of times.
    ///
    /// - Parameter period: The period of each pulsation in seconds.
    /// - Parameter count: The number of pulsations. Leave out to pulsate indefinitely.
    ///
    /// - localizationKey: SKAction.pulsate(period:count:)
    public class func pulsate(period: Double = 5.0, count: Int = 0) -> SKAction {
        
        let originalScale: CGFloat = 1
        let scale = originalScale * 1.5
        let pulseOut = SKAction.scale(to: scale, duration: period)
        let pulseIn = SKAction.scale(to: originalScale, duration: period)
        pulseOut.timingMode = SKActionTimingMode.easeOut
        pulseIn.timingMode = SKActionTimingMode.easeOut
        
        let sequence = SKAction.sequence([pulseOut, pulseIn])
        let action: SKAction
        if count == 0 {
            action = .repeatForever(sequence)
        }
        else {
            action = .repeat(sequence, count: count)
        }
        return action
    }
    
    /// Creates an action that shakes a node for the given number of seconds.
    ///
    /// - Parameter duration: The time in seconds to shake the node.
    ///
    /// - localizationKey: shake(duration:)
    public class func shake(duration: Double = 2.0) -> SKAction {
        
        let amplitudeX: Float = 10
        let amplitudeY: Float = 6
        let numberOfShakes = duration / 0.04
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes.int) {
            let moveX = Float.random(in: 0..<amplitudeX) - amplitudeX / 2
            let moveY = Float.random(in: 0..<amplitudeY) - amplitudeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actionsArray.append(shakeAction)
            actionsArray.append(shakeAction.reversed())
        }
        
        return .sequence(actionsArray)
    }
    
    /// Creates an action that plays an audio file.
    ///
    /// - Parameter fileNamed: The name of the audio file to be played.
    ///
    /// - localizationKey: SKAction.audioPlayAction(fileNamed:)
    fileprivate class func audioPlayAction(fileNamed fileName: String) -> SKAction {
        
        let name = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
        
        return SKAction.customAction(withDuration: 0.0) { node, time in
            
            if let audioNode = node.childNode(withName: name) {
                // Already has an audio node with the same name so just play it.
                audioNode.run(SKAction.play())
            } else {
                // Add an audio node and play it.
                let audioNode = SKAudioNode(fileNamed: fileName)
                audioNode.name = name
                audioNode.autoplayLooped = false
                node.addChild(audioNode)
                audioNode.run(SKAction.play())
            }
        }
    }
    
    /// Creates an action that animates a node to swell up and spin for a number of seconds, and then play a pop sound.
    ///
    /// - Parameter after: The time in seconds to spin the graphic before popping it.
    ///
    /// - localizationKey: SKAction.spinAndPop(after:)
    public class func spinAndPop(after seconds: Double = 2.0) -> SKAction {
        
        let scale: CGFloat = 2.5
        let wait = SKAction.wait(forDuration: 1.0, withRange: 4.0)
        let scaleAction = SKAction.scale(to: scale, duration: seconds)
        scaleAction.timingMode = .easeIn
        let rotateTime = 0.25
        let rotations = Int(seconds / rotateTime) + 1
        let rotate = SKAction.rotate(byAngle: 3.14, duration: rotateTime)
        let spin = SKAction.repeat(rotate, count: Int(rotations))
        
        let soundAction = SKAction.audioPlayAction(fileNamed: "Vox Kit 1 Snare 068.wav")
        
        let oneSpin = SKAction.repeat(rotate, count: 1)
        let megaScale = SKAction.scale(to: CGFloat(scale) * 1.5, duration: 0.25)
        megaScale.timingMode = .easeIn
        
        let scaleAndSpin = SKAction.group([scaleAction, spin])
        let soundScaleAndOneSpin = SKAction.group([megaScale, soundAction, oneSpin])
        
        return .sequence([wait, scaleAndSpin, soundScaleAndOneSpin])
    }
    
    /// Creates an action that animates a node to swirl in a spiral motion around a point for a number of rotations, and then fade out.
    ///
    /// - Parameter after: The time in seconds to swirl the graphic while fading out.
    /// - Parameter rotations: The number of rotations to swirl.
    /// - Parameter from: The point around which to swirl.
    ///
    /// - localizationKey: SKAction.swirlAway(after:rotations:from)
    public class func swirlAway(after seconds: Double = 2.0, rotations: CGFloat = 4.0, from: CGPoint) -> SKAction {
        
        let duration = 4.0
        let spiral = SKAction.spiral(startRadius: 5,
                                     endRadius: 25 * rotations,
                                     angle: CGFloat.pi * 2 * rotations,
                                     centerPoint: from,
                                     duration: duration)
        
        let rotate = SKAction.rotate(byAngle: CGFloat.pi * 4 * rotations, duration: duration)
        let fade = SKAction.fadeOut(withDuration: duration)
        let spiralRotateFade = SKAction.group([spiral, rotate, fade])
        
        return .sequence([.wait(forDuration: seconds), spiralRotateFade])
    }
    
    
    fileprivate class func spiral(startRadius: CGFloat, endRadius: CGFloat, angle
        totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {
        
        func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
            return CGPoint(x: center.x + radius * cos(angle),
                           y: center.y + radius * sin(angle))
        }
        
        // The distance the node will travel away from/towards the center point, per revolution.
        let radiusPerRevolution: CGFloat = 5.0
        
        let action = SKAction.customAction(withDuration: duration) { node, time in
            // Current angle
            let θ = totalAngle * time / CGFloat(duration)
            
            // The equation, r = a + bθ
            let radius = startRadius + radiusPerRevolution * θ
            
            node.position = pointOnCircle(angle: θ, radius: radius, center: centerPoint)
        }
        
        return action
    }

    /// Creates an action that moves a node to a position, animated over duration in seconds, and optionally plays a sound.
    ///
    /// - Parameter to: The point to move to.
    /// - Parameter duration: The time over which to move the graphic.
    /// - Parameter sound: The file name of the sound to be played (optional).
    ///
    /// - localizationKey: SKAction.move(to:duration:sound:)
    public class func move(to position: CGPoint, duration: Double = 0.0, sound: String? = nil) -> SKAction {
        
        let moveAction = SKAction.move(to: position, duration: duration)
        moveAction.timingMode = .easeIn
        
        if let soundFileName = sound {
            let soundAction = SKAction.audioPlayAction(fileNamed: soundFileName)
            return SKAction.sequence([soundAction, moveAction])
        } else {
            return moveAction
        }
    }
    
    /// Creates an action that rotates a node continuously, with a given period of rotation.
    ///
    /// - Parameter period: The period of each rotation in seconds.
    ///
    /// - localizationKey: SKAction.spin(period:)
    public class func spin(period: Double = 2.0) -> SKAction {
        
        let action = SKAction.rotate(byAngle: CGFloat.pi * 2.0, duration: max(period, 0.1))
        return .repeatForever(action)
        
    }

}

