//
//  ContentView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var pdfURL: URL?
     @State private var selectedPage: Int = 1
     @State private var readFromPage: Int = 1

     @State private var isReading = false
     @State private var isLecturing = false
     
     @ObservedObject private var synthesizerManager = SynthesizerManager()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LocalFilesView(pdfURL: $pdfURL)) {
                    Btn(title: "Select Local File")
                }
                NavigationLink(destination: FetchUrlView(pdfURL: $pdfURL)) {
                           Btn(title:"Select URL")
               }
                NavigationLink(destination: HistoryView()) {
                         Btn(title:"See last viewed files")
                 }
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
