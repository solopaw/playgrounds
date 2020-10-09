//
//  Image.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

public class Image: _ExpressibleByImageLiteral, Equatable, Hashable {
    
    let path: String
    let description: String
    
    public required init(imageLiteralResourceName path: String) {
        self.path = path
        self.description = Image.parseDescription(from: path)
    }    
    
    public static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.path == rhs.path
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.path)
    }

    public var isEmpty: Bool {
        return path.count == 0
    }

    static private func parseDescription(from path: String) -> String {
        var name = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
        if let atCharRange = name.range(of: "@") {
            name = String(name[..<atCharRange.lowerBound])
        }

        switch name.lowercased() {
        case "camel":
            name = NSLocalizedString("camel", comment: "AX description of an image")
        case "cat":
            name = NSLocalizedString("cat", comment: "AX description of an image")
        case "dog":
            name = NSLocalizedString("dog", comment: "AX description of an image")
        case "dolphin":
            name = NSLocalizedString("dolphin", comment: "AX description of an image")
        case "elephant":
            name = NSLocalizedString("elephant", comment: "AX description of an image")
        case "frog":
            name = NSLocalizedString("frog", comment: "AX description of an image")
        case "horse":
            name = NSLocalizedString("horse", comment: "AX description of an image")
        case "panda":
            name = NSLocalizedString("panda", comment: "AX description of an image")
        case "pig":
            name = NSLocalizedString("pig", comment: "AX description of an image")
        case "smiling-face":
            name = NSLocalizedString("smiling face", comment: "AX description of an image")
        case "snail":
            name = NSLocalizedString("snail", comment: "AX description of an image")
        case "spider":
            name = NSLocalizedString("spider", comment: "AX description of an image")
        case "americanfootball":
            name = NSLocalizedString("american football", comment: "AX description of an image")
        case "baseball":
            name = NSLocalizedString("baseball", comment: "AX description of an image")
        case "basketball":
            name = NSLocalizedString("basketball", comment: "AX description of an image")
        case "billiardball":
            name = NSLocalizedString("billiard ball", comment: "AX description of an image")
        case "rugbyball":
            name = NSLocalizedString("rugby ball", comment: "AX description of an image")
        case "soccerball":
            name = NSLocalizedString("soccer ball", comment: "AX description of an image")
        case "tennisball":
            name = NSLocalizedString("tennis ball", comment: "AX description of an image")
        case "volleyball":
            name = NSLocalizedString("volleyball", comment: "AX description of an image")
        case "alien":
            name = NSLocalizedString("alien", comment: "AX description of an image")
        case "bot":
            name = NSLocalizedString("robot", comment: "AX description of an image")
        case "ghost":
            name = NSLocalizedString("ghost", comment: "AX description of an image")
        case "monster":
            name = NSLocalizedString("monster", comment: "AX description of an image")
        case "ogre":
            name = NSLocalizedString("ogre", comment: "AX description of an image")
        case "cloud":
            name = NSLocalizedString("cloud", comment: "AX description of an image")
        case "comet":
            name = NSLocalizedString("comet", comment: "AX description of an image")
        case "star":
            name = NSLocalizedString("star", comment: "AX description of an image")
        case "cosmicbus":
            name = NSLocalizedString("cosmic bus", comment: "AX description of an image")
        case "spacethebluefrontier":
            name = NSLocalizedString("space, the blue frontier", comment: "AX description of an image")
        case "spacethegreenfrontier":
            name = NSLocalizedString("space, the green frontier", comment: "AX description of an image")
        case "spacethepurplefrontier":
            name = NSLocalizedString("space, the purple frontier", comment: "AX description of an image")
        case "blackhole":
            name = NSLocalizedString("black hole", comment: "AX description of an image")
        case "blu1":
            name = NSLocalizedString("blu", comment: "AX description of an image")
        case "blu2":
            name = NSLocalizedString("blu", comment: "AX description of an image")
        case "byte1":
            name = NSLocalizedString("byte", comment: "AX description of an image")
        case "byte2":
            name = NSLocalizedString("byte", comment: "AX description of an image")
        case "carmine1":
            name = NSLocalizedString("carmine", comment: "AX description of an image")
        case "carmine2":
            name = NSLocalizedString("carmine", comment: "AX description of an image")
        case "hopper1":
            name = NSLocalizedString("hopper", comment: "AX description of an image")
        case "hopper2":
            name = NSLocalizedString("hopper", comment: "AX description of an image")

        default:
            break
        }

        return name
    }
}

// MARK: Background image overlays

public enum Overlay : Int {
    case gridWithCoordinates
    case cosmicBus
    
    func image() -> Image {
        switch self {
        case .gridWithCoordinates:
            return Image(imageLiteralResourceName: "GridCoordinates")
        case .cosmicBus:
            return Image(imageLiteralResourceName: "CosmicBus")
        }
    }
}
