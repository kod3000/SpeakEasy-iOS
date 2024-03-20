//
//  ContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import SwiftUI
import Alamofire


struct SelectUrlView: View {
    var body: some View {
        NavigationLink(destination: FetchUrlView()) {
            Btn(title:"Select URL")
        }
    }
}
struct LastUsedView: View {
    var body: some View {
        NavigationLink(destination: HistoryView()) {
            Btn(title:"See last viewed files")
        }
    }
}
struct PdfView: View {
    var body: some View {
        NavigationLink(destination: PDFContentView()) {
            Btn(title:"Test PDF View")
        }
    }
}
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LocalFilesView()) {
                    Btn(title: "Select Local File")
                }
                SelectUrlView()
                LastUsedView()
                PdfView()
            }
            .padding()
        }
    }
    // TODO: Implement logic for url view
    // TODO: Implement logic for local file view
    // TODO: Implement logic for history (last used) view
    // TODO: Missing the logic of loading in the file to
    // be read.
    // TODO: Missing the display logic for the text itself
    // TODO: create backend for regex

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
