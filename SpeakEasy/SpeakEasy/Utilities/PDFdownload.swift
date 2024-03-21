//
//  PDFdownload.swift
//  SpeakEasy
//
//  Created by username on 3/21/24.
//

import Foundation
import Alamofire


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
