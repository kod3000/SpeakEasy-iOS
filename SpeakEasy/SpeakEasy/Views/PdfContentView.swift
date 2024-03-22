//
//  PdfContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import AVFoundation
import Alamofire
import PDFKit
import RxCocoa
import RxSwift
import SwiftUI

struct PDFContentView: View {

  var pdfURL: URL
  @Binding var selectedPage: Int
  @Binding var readFromPage: Int
  @Binding var isReading: Bool
  @Binding var isLecturing: Bool
  var synthesizerManager: SynthesizerManager
  @State private var pdfURLEntered: String = "https://static.kod.us/files/swebok-v3.pdf"
    var onClose: () -> Void

  var body: some View {
     ZStack(alignment: .topTrailing) {
    VStack {
      if isLecturing {
        Button(action: {
          // Your action goes here
          print("Reading Page \(readFromPage)")
          self.selectedPage = readFromPage
        }) {
          Text("Reading Page \(readFromPage)").padding()
            .foregroundColor(.primary)
        }
      }
      if synthesizerManager.isSpeaking {
        ZStack {
          ScrollView {
            Text(synthesizerManager.displayText)
              .multilineTextAlignment(.leading)
              .frame(minWidth: 0, maxWidth: .infinity)
              .lineSpacing(2)
              .padding()
          }
          .frame(height: 120)
          .background(Color.gray.opacity(0.1))
          .cornerRadius(5)
          .padding()
        }
      }
      PDFKitView(url: pdfURL, selectedPage: $selectedPage)
        .edgesIgnoringSafeArea(.all)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(1..<numberOfPages(in: pdfURL) + 1, id: \.self) { pageNumber in
            VStack {
              Image(systemName: "doc.text.image")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 80)
                .background(selectedPage == pageNumber ? Color.blue : Color.gray.opacity(0.3))
                .cornerRadius(10)
                .padding(.bottom, 5)

              Text("Pg. \(pageNumber)")
                .foregroundColor(selectedPage == pageNumber ? .blue : .primary)
            }
            .padding()
            .onTapGesture {
              self.selectedPage = pageNumber
            }
            .animation(.default, value: selectedPage)
          }
        }
      }
      Button(action: {
        configureAudioSession()
        if synthesizerManager.isSpeaking {
          // its currently speaking
          isReading = false
          synthesizerManager.pauseSpeaking()
          return
        }
        if let pdfDocument = PDFDocument(url: pdfURL),
          let text = extractText(from: pdfDocument, pageIndex: selectedPage - 1)
        {
          // remove first line from text
          let lines = text.components(separatedBy: "\n")
          let freshPage = lines.dropFirst().joined(separator: "\n")
          isLecturing = true
          readFromPage = selectedPage
          isReading.toggle()
          synthesizerManager.speak(freshPage)
        }
      }) {
        Text(isLecturing ? (isReading ? "Pause Reading" : "Continue Reading") : "Read Aloud")
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(10)
          .padding(5)
      }
    }
      Button(action: {
          onClose()
      }) {
                Image(systemName: "xmark")
                    .padding()
                    .foregroundColor(.primary)
                    .background(Color.red.opacity(0.1))
        }
     }
  }
}
struct PDFContentView_Previews: PreviewProvider {
  // Assuming SynthesizerManager can be initialized without configuration
  static let synthesizerManager = SynthesizerManager()
  static let mockPDFURL = URL(string: "https://static.kod.us/files/swebok-v3.pdf")!

  static var previews: some View {
    PDFContentView(
      pdfURL: mockPDFURL,
      selectedPage: .constant(1),
      readFromPage: .constant(1),
      isReading: .constant(false),
      isLecturing: .constant(false),
      synthesizerManager: synthesizerManager,
      onClose: { print("no action in previews my dudes..") }
    )
  }
}
