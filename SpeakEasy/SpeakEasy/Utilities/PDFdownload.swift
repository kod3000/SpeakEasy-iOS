//
//  PDFdownload.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/21/24.
//

import Foundation
import Alamofire


class PDFDownloaderNoSave {
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

class PDFDownloaderSave {
    static func downloadPDF(from urlString: String, completion: @escaping (URL?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                do {
                    let fileManager = FileManager.default
                    let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let savedURL = documentsURL.appendingPathComponent(url.lastPathComponent)
                    try fileManager.moveItem(at: tempLocalUrl, to: savedURL)
                    
                    DispatchQueue.main.async {
                        completion(savedURL)
                    }
                } catch {
                    print("Could not save file: \(error)")
                    DispatchQueue.main.async {
                        // An error occurred
                        completion(nil)
                    }
                }
            } else {
                print("Download Error: \(error?.localizedDescription ?? "Unknown Error")")
                DispatchQueue.main.async {
                    // An error occurred
                    completion(nil)
                }
            }
        }
        downloadTask.resume()
    }
}
