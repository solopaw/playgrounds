//
//  AssessmentLoader.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation

// A convenience class capable of reading entries from Hints.plist for the given page.
struct AssessmentLoader {
    // MARK: Types
    
    enum MessageKey: String {
        case success = "success"
        case solution = "solution"
        case hints = "Hints"
        case dynamicHints = "dynamicHints"
    }
    
    // MARK: Properties
    
    static var messages: [String: Any] = {
        // The assessment plist uses the name Hints.plist to enable Swift Playgrounds to load and display the initial hints automatically.
        guard let assessmentURL = Bundle.main.url(forResource: "Hints", withExtension: "plist"),
              let plist = NSDictionary(contentsOf: assessmentURL) as? [String: Any] else {
            NSLog("Failed to find Hints.plist")
            return [:]
        }
        
        return plist
    }()
    
    // MARK: Methods
    
    static func message(for key: String) -> String? {
        guard let message = messages[key] as? String,
            !message.isEmpty else { return nil }
        
        return message
    }
    
    static func message(for key: MessageKey) -> String? {
        switch key {
        case .success, .solution:
            // The success and solution message is wrapped in a "_LOCALIZABLE_" dictionary above the dictionary containing the "Content", which has the text to display.
            guard let dict = messages[key.rawValue] as? [String: [String: String]],
                let localizedDict = dict["_LOCALIZABLE_"],
                let message = localizedDict["Content"],
                !message.isEmpty else {
                    return nil
            }
            return message
        default:
            return message(for: key.rawValue)
        }
    }
    
    static func hints(for key: MessageKey = .hints) -> [String]? {
        guard let hintDicts = messages[key.rawValue] as? [[String: [String: String]]] else { return nil }
        // The hints are wrapped in a "_LOCALIZABLE_" dictionary above the dictionary containing the "Content", which has the text to display.
        let hints = hintDicts.compactMap( { $0["_LOCALIZABLE_"] } ).compactMap( { $0["Content"] } )
        let validHints = hints.filter { !$0.isEmpty }
        return validHints.isEmpty ? nil : validHints
    }
}
