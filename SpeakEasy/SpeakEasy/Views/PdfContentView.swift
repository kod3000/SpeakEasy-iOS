//
//  PdfContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import AVFoundation
import Alamofire
import PDFKit
import SwiftUI

struct PDFContentView: View {
  @State private var pdfURL: URL?
  @State private var pdfURLEntered: String = "https://static.kod.us/files/swebok-v3.pdf"
  @State private var selectedPage: Int = 1
  @State private var readFromPage: Int = 1

  @State private var isReading = false
  @State private var isLecturing = false  // know if we started the lecture or not
  @State private var synthesizer = SpeechSynthesizer()

  var body: some View {
    VStack {
      if let pdfURL = pdfURL {
        if isLecturing {
            Button(action: {
                   // Your action goes here
                   print("Reading Page \(readFromPage)")
                self.selectedPage = readFromPage
               }) {
                   Text("Reading Page \(readFromPage)").padding()
               }
        }
          if isLecturing && isReading{              
              ScrollView {
                  Text(synthesizer.displayText())
                      .padding()
              }
              .frame(height: 100)
              .background(Color.gray.opacity(0.1))
              .cornerRadius(5)
              .padding()
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
                          if synthesizer.currentlySpeaking() {
                            // its currently speaking
                            isReading = false
                            synthesizer.speaker().pauseSpeaking(at: .word)
                              return
                          }
                          // TODO: add in a check to know if speaking or not
                          if let pdfDocument = PDFDocument(url: pdfURL),
                            let text = extractText(from: pdfDocument, pageIndex: selectedPage - 1)
                          {
                            // remove first line from text
                            let lines = text.components(separatedBy: "\n")
                            let freshPage = lines.dropFirst().joined(separator: "\n")
                            isLecturing = true
                            readFromPage = selectedPage
                            isReading.toggle()
                            synthesizer.speak(freshPage)
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
          
          
      } else {
        TextField("Enter Pdf Url", text: $pdfURLEntered)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
          Button(action: {
              PDFDownloader.downloadPDF(from: pdfURLEntered) { url in
                  DispatchQueue.main.async {
                      self.pdfURL = url
                  }
              }
          }) {
              Text("Download PDF")
                  .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
                  .padding()
                  .foregroundColor(.white)
                  .background(Color.blue)
                  .cornerRadius(10)
                  .padding(5)
          }
      }
    }
  }
}
struct PdfContentView_Previews: PreviewProvider {
  static var previews: some View {
    PDFContentView()
  }
}
