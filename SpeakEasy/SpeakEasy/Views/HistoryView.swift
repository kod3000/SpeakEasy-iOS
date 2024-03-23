//
//  HistoryView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

// TODO: Here we would have a history of
// the pdf files the user has played.
// clicking on a url item sets it as the active pdf
//                        Text(item.urlString ?? "Unknown Location") // debug
//                            .font(.subheadline)
//                            .foregroundColor(.gray)

import SwiftUI

// Here we would have a history of the pdf files the user has played. history should not repeat the same file

struct HistoryView: View {
  @State private var historyItems: [PDFHistory] = []
  @State private var isEditing = false
  @State private var editingItem: PDFHistory?
  @Binding var pdfURL: URL?

  private func loadHistory() {
    historyItems = CoreDataManager.shared.fetchPDFHistory()
  }

  var body: some View {
    NavigationView {
      Group {
        if historyItems.isEmpty {
          // Display a message when there is no history
          Text("No history as of yet")
            .foregroundColor(.gray)
            .italic()
        } else {
          // List view for displaying history items with swipe actions
          List {
            ForEach(historyItems, id: \.self) { item in
              VStack(alignment: .leading) {
                Text(item.friendlyName ?? "Unknown")
                Text(item.fileName ?? "Unknown File Name")
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
              .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button("View") {
                  if let urlString = item.urlString, let url = URL(string: urlString) {
                    self.pdfURL = url
                  } else {
                    print("Invalid URL string: \(item.urlString ?? "nil")")
                  }
                }
                .tint(.blue)
                Button("Edit") {
                  self.editingItem = item
                  self.isEditing = true
                }
                .tint(.yellow)
                Button(role: .destructive) {
                  CoreDataManager.shared.deletePDFHistory(
                    item,
                    completion: { deleted, error in
                      if let error = error {
                        print("Error: \(error)")
                      } else if deleted {
                        print("Entry deleted...")
                      }
                    })
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              }
            }
          }
        }
      }
      .navigationTitle("History")
      .onAppear(perform: loadHistory)
      .sheet(isPresented: $isEditing) {
          if let editingItem = editingItem {

              EditView(editingItem: editingItem) { newFriendlyName in
                  if let index = historyItems.firstIndex(where: { $0.id == editingItem.id }) {
                      historyItems[index].friendlyName = newFriendlyName
                      editingItem.friendlyName = newFriendlyName
                      CoreDataManager.shared.updatePDFHistory(editingItem) { updated, error in
                           if let error = error {
                               print("Error: \(error)")
                           } else if updated {
                               print("Update entry in database.")
                           } else {
                               print("Something else happened in the database.")
                           }
                       }
                  }
                  isEditing = false
              }
          }
      }
    }
  }

  // Utility to format the date
  private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }()
}

// move to components when completed ..
struct EditView: View {
    @State private var friendlyName: String
    let editingItem: PDFHistory
    let onDone: (String) -> Void

    init(editingItem: PDFHistory, onDone: @escaping (String) -> Void) {
        self.editingItem = editingItem
        self.onDone = onDone
        _friendlyName = State(initialValue: editingItem.friendlyName ?? "")
        print("Initializing EditView with friendlyName: \(self.friendlyName)")
    }

    var body: some View {
        VStack {
            TextField("Name", text: $friendlyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.primary)
                .padding()
            
            Button("Save") {
                onDone(friendlyName)
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
  @State static var pdfURL: URL? = nil

  static var previews: some View {
    HistoryView(pdfURL: $pdfURL)
  }
}
