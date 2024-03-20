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


func extractText(from pdfDocument: PDFDocument, pageIndex: Int) -> String? {
    guard let page = pdfDocument.page(at: pageIndex) else { return nil }
    return page.string
}
