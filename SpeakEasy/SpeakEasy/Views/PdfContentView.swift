//
//  PdfContentView.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import SwiftUI
import PDFKit
import Alamofire

struct PDFKitView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // You might want to add code here if you need to update the PDFView when the SwiftUI view updates.
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
            DispatchQueue.main.async { // Ensure UI update is on the main thread
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

func extractText(from pdfDocument: PDFDocument) -> String? {
    var extractedText = ""
    for pageIndex in 0..<pdfDocument.pageCount {
        guard let page = pdfDocument.page(at: pageIndex) else { continue }
        guard let pageText = page.string else { continue }
        extractedText += pageText
    }
    return extractedText.isEmpty ? nil : extractedText
}

struct PDFContentView: View {
    @State private var pdfURL: URL?

    var body: some View {
        VStack {
            if let pdfURL = pdfURL {
                PDFKitView(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
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
