//
//  SpeechService.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import Foundation
import AVFoundation

class SpeechSynthesizer {
    private let synthesizer = AVSpeechSynthesizer()
    private var isSpeaking: Bool = false

    func speak(_ text: String) {
        if isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        } else {
            let utterance = AVSpeechUtterance(string: text)
            synthesizer.speak(utterance)
        }
        isSpeaking.toggle()
    }
}
