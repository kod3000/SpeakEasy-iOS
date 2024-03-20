//
//  General.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
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

// remove ref citations pattern
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
    return removeRefCit(text:page.string!)
}
