//
//  ContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var pdfURL: URL?
     @State private var selectedPage: Int = 1
     @State private var readFromPage: Int = 1

     @State private var isReading = false
     @State private var isLecturing = false
    @State private var backgroundOffset = CGSize.zero

     @ObservedObject private var synthesizerManager = SynthesizerManager()
    
    var body: some View {

        ZStack {
            // Background
                      Image("background1")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .offset(x: backgroundOffset.width, y: backgroundOffset.height)
                          .animation(.linear(duration: 10).repeatForever(autoreverses: true), value: backgroundOffset)
                          .onAppear {
                              backgroundOffset = CGSize(width: 20, height: 20)
                          }
                          .edgesIgnoringSafeArea(.all)
            VStack {
                if let pdfURL = pdfURL {
                    PDFContentView(pdfURL: pdfURL, selectedPage: $selectedPage, readFromPage: $readFromPage, isReading: $isReading, isLecturing: $isLecturing, synthesizerManager: synthesizerManager,
                                   onClose: { self.pdfURL = nil }
                    )
                } else {
                    NavigationView {
                        VStack {
                            NavigationLink(destination: FetchUrlView(pdfURL: $pdfURL)) {
                                Btn(title:"Select URL")
                            }
                            NavigationLink(destination: LocalFilesView(pdfURL: $pdfURL)) {
                                Btn(title: "Select Local File")
                            }
                            NavigationLink(destination: HistoryView(pdfURL: $pdfURL)) {
                                Btn(title:"See last viewed files")
                            }
                        }
                    }
                }
            }
            .padding()
            
        }
        .onAppear {
                    // animate sligthly on appear
                    backgroundOffset = CGSize(width: -20, height: -20)
                }
            }

    // TODO: create backend for regex
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
