//
//  PatternLogicFactory.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import Foundation

//let fetchedRules: [String: Any] = [
//    "rules": [
//        [
//            "id": 1,
//            "pattern": "\\[[1-9]+\\*+,[^\\]]*\\]",
//            "logicName": "removeRefCit"
//        ],
//        [
//            "id": 2,
//            "pattern": "\\b\\d+(\\.\\d+)*\\b",
//            "logicName": "sectionFinder"
//        ],
//        [
//            "id": 3,
//            "pattern": "(\\w+)-(\\n?)(\\w+)",
//            "logicName": "restoreSplitWords"
//        ]
//    ]
//]

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
        case "restoreSplitWords":
            return { match, originalText in
                if let matchRange = Range(match.range, in: originalText) {
                    return "\(originalText[matchRange])"
                }
                return originalText
            }
        case "removeRefCit":
            return { match, originalText in
                return ""
            }
        default:
            return nil
        }
    }
}



