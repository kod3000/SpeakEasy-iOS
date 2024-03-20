//
//  HistoryList.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import SwiftUI

// ListView to display last used items
struct ListHistoryView: View {
    var body: some View {
        List {
            Text("Document PDF 1")
            Text("Document PDF 2")
            Text("Document PDF 3")
        }
    }
    // TODO: Here we would have a history of
    // the pdf files the user has played.
    // history should not repeat the same file
    
}
