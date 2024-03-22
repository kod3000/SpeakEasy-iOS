//
//  PDFPageThumbnails.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/21/24.
//

import Foundation
import SwiftUI
import PDFKit

func pdfPageThumbnail(pdfURL: URL, pageNumber: Int, width: CGFloat = 60) -> some View {
  guard let pdfDocument = PDFDocument(url: pdfURL),
    let page = pdfDocument.page(at: pageNumber - 1)
  else {
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
