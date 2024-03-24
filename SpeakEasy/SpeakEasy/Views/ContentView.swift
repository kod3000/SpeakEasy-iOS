//
//  ContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import Alamofire
import SwiftUI

struct ContentView: View {
  @State private var pdfURL: URL?
  @State private var selectedPage: Int = 1
  @State private var readFromPage: Int = 1

  @State private var isReading = false
  @State private var isLecturing = false
  @State private var backgroundOffset = CGSize.zero

  @ObservedObject private var synthesizerManager = SynthesizerManager()

  var body: some View {
    NavigationView {
      ZStack {
        Image("background1")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .offset(x: backgroundOffset.width, y: backgroundOffset.height)
          .animation(
            .linear(duration: 15).repeatForever(autoreverses: true), value: backgroundOffset
          )
          .onAppear {
            backgroundOffset = CGSize(width: 20, height: 20)
          }
          .edgesIgnoringSafeArea(.all)
          .background(Color.black)

        VStack {
          if let pdfURL = pdfURL {
            PDFContentView(
              pdfURL: pdfURL, selectedPage: $selectedPage, readFromPage: $readFromPage,
              isReading: $isReading, isLecturing: $isLecturing,
              synthesizerManager: synthesizerManager,
              onClose: { self.pdfURL = nil }
            )
          } else {
            Group {

              VStack {
                Text("Speak Easy").bold().font(.largeTitle)
                  .foregroundColor(.white)
                  .background(Color.black)
                  .padding(2)
                  .multilineTextAlignment(.leading)
                Text("Your PDFs spoken to you on the go.").bold().font(.subheadline)
                  .foregroundColor(.white)
                  .background(Color.black.opacity(0.3))
                  .padding(2)
                  .multilineTextAlignment(.leading)
                NavigationLink(destination: FetchUrlView(pdfURL: $pdfURL)) {
                  Btn(title: "Select URL")
                }.background(Color.black)
                NavigationLink(destination: LocalFilesView(pdfURL: $pdfURL)) {
                  Btn(title: "Select Local File")
                }.background(Color.black)
                NavigationLink(destination: HistoryView(pdfURL: $pdfURL)) {
                  Btn(title: "See last viewed files")
                }.background(Color.black)

              }
              .padding()
            }

          }

        }
        .padding()
        .shadow(radius: 5)

      }
      .onAppear {
        // animate sligthly on appear
        backgroundOffset = CGSize(width: -20, height: -20)
      }
    }.navigationBarTitle("", displayMode: .inline)
      .navigationBarHidden(true)
      .background(Color.clear)
  }

  // TODO: create backend for regex
}
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
