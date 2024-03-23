//
//  FetchUrlView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import SwiftUI

struct FetchUrlView: View {
    @Binding var pdfURL: URL?
     @State private var pdfURLEntered: String = "https://static.kod.us/files/swebok-v3.pdf"

     var body: some View {
         VStack {
             TextField("Enter Pdf Url", text: $pdfURLEntered)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .padding()
             Button(action: {
                 PDFDownloaderSave.downloadPDF(from: pdfURLEntered) { url in
                     DispatchQueue.main.async {
                         self.pdfURL = url
                         CoreDataManager.shared.savePDFURL(url: (url)!) { added, error in
                             if let error = error {
                                 print("Error: \(error)")
                             } else if added {
                                 print("URL was added to the database.")
                             } else {
                                 print("URL was already in the database.")
                             }
                         }
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
         }.padding()
     }
}

struct FetchUrlView_Previews: PreviewProvider {
    @State static var pdfURL: URL? = nil
    static var previews: some View {
        FetchUrlView(pdfURL: $pdfURL)
    }
}
