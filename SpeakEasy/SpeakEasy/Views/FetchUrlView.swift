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

struct FetchUrlView_Previews: PreviewProvider {
    @State static var pdfURL: URL? = nil
    static var previews: some View {
        FetchUrlView(pdfURL: $pdfURL)
    }
}
