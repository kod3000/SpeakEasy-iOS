//
//  General.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import Foundation
import AVFoundation
import PDFKit

/// Used to start the audio session on device
/// - Notes: 
///     This is required to play audio on the device
///     Ideally, this should be called in the `init` of the `AppDelegate`
func configureAudioSession() {
    // TODO: Add better error handling
    // TODO: What if the app goes to the background?
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
                "pattern": "\\n\\b\\d+(\\.\\d+)*\\b",
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
func restoreSplitWords(text: String) -> String {
    let regexPattern = "(\\w+)-(\\n?)(\\w+)"
    guard let regex = try? NSRegularExpression(pattern: regexPattern) else { return text }
    let range = NSRange(text.startIndex..., in: text)
    
    let matches = regex.matches(in: text, options: [], range: range).reversed() // Reverse to maintain indices
    var modifiedText = text
    
    for match in matches {
        guard let totalRange = Range(match.range, in: text),
              let firstPartRange = Range(match.range(at: 1), in: text),
              let secondPartRange = Range(match.range(at: 3), in: text) else {
            continue
        }
        let firstPart = String(text[firstPartRange])
        let secondPart = String(text[secondPartRange])
        // Check for newline in the matched range
        if let newlineRange = Range(match.range(at: 2), in: text), !text[newlineRange].isEmpty {
            // Construct replacement string without newline
            let replacement = firstPart + secondPart
            // Calculate start index for replacement based on current state of modifiedText
            if let startIndex = modifiedText.index(modifiedText.startIndex, offsetBy: totalRange.lowerBound.utf16Offset(in: text), limitedBy: modifiedText.endIndex),
               let endIndex = modifiedText.index(modifiedText.startIndex, offsetBy: totalRange.upperBound.utf16Offset(in: text), limitedBy: modifiedText.endIndex) {
                modifiedText.replaceSubrange(startIndex..<endIndex, with: replacement)
            }
        }
    }
    return modifiedText
}


// Utility For PDF text extration, and perform cleanup on text itself
func extractText(from pdfDocument: PDFDocument, pageIndex: Int) -> String? {
    guard let page = pdfDocument.page(at: pageIndex) else { return nil }
    // create the text processor
    let textProcessor = TextProcessor()
    // pass in the text processor to gather rules for formating
    // keep in mind some rules are single pass for performance
    // later they can be applied to the display text for more fine grain
    fetchRegexRules(textProcessor: textProcessor)
    return textProcessor.process(text:page.string!)
    //    return removeRefCit(text:page.string!)
}



//
// ************************* PDF Centric Functions *************************
//

  func getPageRange(for url: URL, selectedPage: Int) -> [Int] {
    let totalPages = numberOfPages(in: url)
    let previousPage = max(selectedPage - 1, 1)
    let nextPage = min(selectedPage + 1, totalPages)

    return Array((previousPage...nextPage).sorted())
  }
  func numberOfPages(in url: URL) -> Int {
    guard let document = PDFDocument(url: url) else { return 0 }
    return document.pageCount
  }

