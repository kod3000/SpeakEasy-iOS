//
//  SpeechService.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//
import Foundation
import AVFoundation
import RxSwift

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private var isSpeaking: Bool = false


    private var sentences = [String]()
    private var currentSentenceIndex:Int = 0

    var readingText = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        processSentences(text: text)
        readSentence()
    }
    
    func speaker()->AVSpeechSynthesizer{
        return synthesizer
    }
    
    func currentlySpeaking() -> Bool{
        return isSpeaking
    }
        
    private func processSentences(text: String){
        sentences = text.components(separatedBy: ". ").map { $0 + "." }
        currentSentenceIndex = 0
    }
    
    private func readSentence() {
        guard currentSentenceIndex < sentences.count else {
            isSpeaking = false
            return
        }
        let sentence = sentences[currentSentenceIndex]
        readingText.onNext(sentence)
        let utterance = AVSpeechUtterance(string: sentence)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    // Implement delegate methods to update isSpeaking
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
         currentSentenceIndex += 1
         if currentSentenceIndex < sentences.count {
             readSentence()
         } else {
             isSpeaking = false
         }
     }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isSpeaking = true
    }
}
