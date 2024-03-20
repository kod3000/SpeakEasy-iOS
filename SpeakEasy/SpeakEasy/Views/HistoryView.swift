//
//  HistoryView.swift
//  SpeakEasy
//
//  Created by username on 3/20/24.
//

import SwiftUI


// Here we would have a history of the pdf files the user has played. history should not repeat the same file


struct HistoryView: View {
    var body: some View {
        ListHistoryView()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
