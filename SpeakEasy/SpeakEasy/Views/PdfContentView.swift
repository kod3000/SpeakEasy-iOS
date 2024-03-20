//
//  PdfContentView.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import SwiftUI
import PDFKit
import Alamofire
import AVFoundation


func extractText(from pdfDocument: PDFDocument, pageIndex: Int) -> String? {
    guard let page = pdfDocument.page(at: pageIndex) else { return nil }
    return page.string
}


struct PDFKitView: UIViewRepresentable {
    var url: URL
    @Binding var selectedPage: Int

    // TODO: count the pages
    // TODO: ask the user what page they want to read.
    // TODO: record the page number
    // TODO: extract only the text from the selected page
    // TODO: give the page to the user as it the text is being read
    // TODO: allow the user to pause and play the speech text
     
        
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        guard let document = uiView.document else { return }
        // Check if the selected page number is within the bounds of the document's pages
        if selectedPage >= 1 && selectedPage <= document.pageCount {
            let pageIndex = selectedPage - 1 // Adjust for zero-based index
            if let page = document.page(at: pageIndex) {
                uiView.go(to: page)
            }
        }
    }
}
class PDFDownloader {
    static func downloadPDF(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        let destination: DownloadRequest.Destination = { _, _ in
            let directory = FileManager.default.temporaryDirectory
            let filePath = directory.appendingPathComponent(UUID().uuidString + ".pdf")
            return (filePath, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url, to: destination).response { response in
            DispatchQueue.main.async {
                if response.error == nil, let pdfURL = response.fileURL {
                    completion(pdfURL)
                } else {
                    print("Error downloading PDF: \(response.error?.localizedDescription ?? "unknown error")")
                    completion(nil)
                }
            }
        }
    }
}

struct PDFContentView: View {
    @State private var pdfURL: URL?
    @State private var selectedPage: Int = 1
    @State private var synthesizer = SpeechSynthesizer()

    var body: some View {
        VStack {
            if let pdfURL = pdfURL {
                PDFKitView(url: pdfURL, selectedPage: $selectedPage)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    TextField("Enter page number", value: $selectedPage, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Read Aloud") {
                        // Assuming PDFDocument is available here; you might need to adjust scope.
                        // You would extract text and start speaking here.
                        if let pdfDocument = PDFDocument(url: pdfURL),
                           let text = extractText(from: pdfDocument, pageIndex: selectedPage - 1) {
                            synthesizer.speak(text)
                        }
                    }
                }
            } else {
                Button("Download PDF") {
                    PDFDownloader.downloadPDF(from: "https://static.kod.us/files/swebok-v3.pdf") { url in
                        DispatchQueue.main.async {
                            self.pdfURL = url
                        }
                    }
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
