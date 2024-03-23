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
        Group {
            if historyItems.isEmpty {
                // Display a message when there is no history
                Text("No history as of yet")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                // The original List view for displaying history items
                List(historyItems, id: \.self) { item in
                    VStack(alignment: .leading) {
                        Text(item.friendlyName ?? "Unknown")
                        Text(item.fileName ?? "Unknown File Name")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(item.urlString ?? "Unknown Location")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        if let accessDate = item.access {
                            Text("Accessed: \(itemFormatter.string(from: accessDate))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text("Access date not available")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadHistory)
    }
    
    // Utility to format the date
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
}
