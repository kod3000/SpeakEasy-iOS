//
//  TextProcessor.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import Foundation


struct TextProcessingRule {
    let pattern: String
    let replacement: (NSTextCheckingResult, String) -> String
}

class TextProcessor {
    var rules: [TextProcessingRule] = []
    func process(text: String) -> String {
        var processedText = text
        for rule in rules {
            guard let regex = try? NSRegularExpression(pattern: rule.pattern) else { continue }
            let matches = regex.matches(in: processedText, range: NSRange(processedText.startIndex..., in: processedText))
            // Reverse to maintain correct indexing when replacing
            for match in matches.reversed() {
                let replacementString = rule.replacement(match, processedText)
                if let range = Range(match.range, in: processedText) {
                    processedText.replaceSubrange(range, with: replacementString)
                }
            }
        }
        return processedText
    }
    func addRule(_ rule: TextProcessingRule) {
        rules.append(rule)
    }
}
