//
//  PatternLogicFactory.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import Foundation
class PatternLogicFactory {
    static func logic(forName name: String) -> ((NSTextCheckingResult, String) -> String)? {
        switch name {
        case "sectionFinder":
            return { match, originalText in
                if let matchRange = Range(match.range, in: originalText) {
                    return "\n\nSection \(originalText[matchRange])\n"
                }
                return originalText
            }

        default:
            return nil
        }
    }
}



