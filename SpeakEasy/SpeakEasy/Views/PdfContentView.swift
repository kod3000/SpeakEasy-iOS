//
//  PdfContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import SwiftUI
import PDFKit
import Alamofire
import AVFoundation


struct PDFKitView: UIViewRepresentable {
    var url: URL
    @Binding var selectedPage: Int

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

        
        guard let url = URL(string: urlString), url.pathExtension.lowercased() == "pdf" else {
            print("Invalid URL or not a PDF")
            completion(nil)
            return
        }
        
        // TODO: Read mime type to ensure we are recieving a pdf file
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
    @State private var pdfURLEntered: String = "https://static.kod.us/files/swebok-v3.pdf"
    @State private var selectedPage: Int = 1
    @State private var synthesizer = SpeechSynthesizer()

    var body: some View {
        VStack {
            if let pdfURL = pdfURL {
                PDFKitView(url: pdfURL, selectedPage: $selectedPage)
                    .edgesIgnoringSafeArea(.all)
                TextField("Enter page number", value: $selectedPage, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                ScrollView(.horizontal, showsIndicators: false) {
                       HStack {
                        ForEach(getPageRange(for: pdfURL, selectedPage: selectedPage), id: \.self) { pageNumber in
                            VStack {
                                pdfPageThumbnail(pdfURL: pdfURL, pageNumber: pageNumber)
                                    .frame(width: 60, height: 80)
                                    .cornerRadius(5)
                                    .padding(.bottom, 5)
                                
                                Text("Pg. \(pageNumber)")
                            }
                            .padding()
                            .onTapGesture {
                                self.selectedPage = pageNumber
                            }
                        }
                    }
                }
                HStack {
                    Button("Read Aloud") {
                        configureAudioSession()
                        // TODO: add in a check to know if speaking or not
                        if let pdfDocument = PDFDocument(url: pdfURL),
                           let text = extractText(from: pdfDocument, pageIndex: selectedPage - 1) {
                            // remove first line from text
                            let lines = text.components(separatedBy: "\n")
                            let newText = lines.dropFirst().joined(separator: "\n")
                            synthesizer.speak(newText)
                        }
                    }
                }
            } else {
                    TextField("Enter Pdf Url", text: $pdfURLEntered)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Download Pdf") {
                        PDFDownloader.downloadPDF(from: pdfURLEntered) { url in
                            DispatchQueue.main.async {
                                self.pdfURL = url
                            }
                        }
                }
                
            }
        }
    }
    func getPageRange(for url: URL, selectedPage: Int) -> [Int] {
        let totalPages = numberOfPages(in: url)
        let previousPage = max(selectedPage - 1, 1)
        let nextPage = min(selectedPage + 1, totalPages)
        
        return Array((previousPage...nextPage).sorted())
    }

    func numberOfPages(in url: URL) -> Int {
        guard let document = PDFDocument(url: url) else { return 0 }
        return document.pageCount
    }

    func pdfPageThumbnail(pdfURL: URL, pageNumber: Int, width: CGFloat = 60) -> some View {
        guard let pdfDocument = PDFDocument(url: pdfURL),
                let page = pdfDocument.page(at: pageNumber - 1) else {
            return AnyView(EmptyView())
        }

        let pageSize = page.bounds(for: .mediaBox)
        let scale = width / pageSize.width
        let height = pageSize.height * scale
        
        return AnyView(
            Image(uiImage: page.thumbnail(of: CGSize(width: width, height: height), for: .mediaBox))
                .resizable()
                .aspectRatio(contentMode: .fit)
        )
    }
}
struct PdfContentView_Previews: PreviewProvider {
    static var previews: some View {
        PDFContentView()
    }
}
