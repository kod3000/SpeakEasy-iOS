//
//  PDFKitView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/21/24.
//

import SwiftUI
import PDFKit

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
      let pageIndex = selectedPage - 1  // Adjust for zero-based index
      if let page = document.page(at: pageIndex) {
        uiView.go(to: page)
      }
    }
  }
}
