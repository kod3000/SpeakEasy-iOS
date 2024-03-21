//
//  SynthesizerManager.swift
//  SpeakEasy
//
//  Created by username on 3/21/24.
//

import Foundation
import RxSwift
import SwiftUI

class SynthesizerManager: ObservableObject {
    @Published var displayText: String = ""
    private let synthesizer = SpeechSynthesizer()
    private var disposeBag = DisposeBag()
    
    init() {
        setupBindings()
    }
    
    func speak(_ text: String) {
        synthesizer.speak(text)
    }
    
    var isSpeaking: Bool {
        return synthesizer.currentlySpeaking()
    }
    
    func pauseSpeaking() {
        synthesizer.speaker().pauseSpeaking(at: .word)
    }
    
    private func setupBindings() {
        synthesizer.readingText
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.displayText = text
            })
            .disposed(by: disposeBag)
    }
}


