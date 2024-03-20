//
//  General.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import Foundation
import AVFoundation
import PDFKit

func configureAudioSession() {
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio, options: [])
        try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        print("Failed to set up audio session: \(error)")
    }
}

func fetchRegexRules(textProcessor:TextProcessor) {
    // Define the rules as if it coming from a api call
    let fetchedRules: [String: Any] = [
        "rules": [
            [
                "id": 1,
                "pattern": "\\[[1-9]+\\*+,[^\\]]*\\]",
                "logicName": "removeRefCit"
            ],
            [
                "id": 2,
                "pattern": "\\b\\d+(\\.\\d+)*\\b",
                "logicName": "sectionFinder"
            ],
            [
                "id": 3,
                "pattern": "(\\w+)-(\\n?)(\\w+)",
                "logicName": "restoreSplitWords"
            ]
        ]
    ]

    
    // Ensure the 'rules' key contains an array
    if let rules = fetchedRules["rules"] as? [[String: Any]] {
        // Iterate through each rule in the array
        for rule in rules {
            // Extract the logicName and pattern for each rule
            if let logicName = rule["logicName"] as? String,
               let pattern = rule["pattern"] as? String,
               let logic = PatternLogicFactory.logic(forName: logicName) {
                // Create a TextProcessingRule and add it to the textProcessor
                let textRule = TextProcessingRule(pattern: pattern, replacement: logic)
                textProcessor.addRule(textRule)
            }
        }
    }
}



// TODO: Convert the regex patterns into a logic that comes from a server
func removeRefCit(text: String) -> String {
    let regexPattern = "\\[[1-9]+\\*+,[^\\]]*\\]"
    guard let regex = try? NSRegularExpression(pattern: regexPattern) else { return text }
    let range = NSRange(text.startIndex..., in: text)
    return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "\n\n")
}



func findPossibleSections(text: String) -> String {
    let regexPattern = "\\b\\d+(\\.\\d+)*\\b"
    guard let regex = try? NSRegularExpression(pattern: regexPattern) else { return text }
    let range = NSRange(text.startIndex..., in: text)
    let matches = regex.matches(in: text, options: [], range: range)
    var modifiedText = text
    for match in matches {
        let matchRange = Range(match.range, in: text)!
        let matchText = text[matchRange]
        modifiedText = modifiedText.replacingOccurrences(of: matchText, with: "\n\nSection \(matchText)\n")
    }
    return modifiedText
}

func extractText(from pdfDocument: PDFDocument, pageIndex: Int) -> String? {
    guard let page = pdfDocument.page(at: pageIndex) else { return nil }
    //    return removeRefCit(text:page.string!)
    let textProcessor = TextProcessor()
    fetchRegexRules(textProcessor: textProcessor)
    return textProcessor.process(text:page.string!)
}
