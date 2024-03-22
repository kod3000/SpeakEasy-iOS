//
//  HistoryList.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//


import SwiftUI

// ListView to display last used items
struct ListHistoryView: View {
    @State private var historyItems: [PDFHistory] = []

     private func loadHistory() {
         historyItems = CoreDataManager.shared.fetchPDFHistory()
     }

    // TODO: Here we would have a history of
    // the pdf files the user has played.
    // history should not repeat the same file
    // clicking on a url item sets it as the active pdf
    var body: some View {
        List(historyItems, id: \.self) { item in
            Text(item.urlString ?? "Unknown URL")
        }
        .onAppear(perform: loadHistory)
    }
    
}
