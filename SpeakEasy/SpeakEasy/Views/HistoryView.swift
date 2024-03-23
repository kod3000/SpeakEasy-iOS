//
//  HistoryView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import SwiftUI


struct HistoryView: View {
  @State private var historyItems: [PDFHistory] = []
  @State private var isEditing = false
    @State private var editingItem: PDFHistory?
  @Binding var pdfURL: URL?

  private func loadHistory() {
    historyItems = [] // lets reset the array
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
      .sheet(item: $editingItem) { (item: PDFHistory) in
                    EditView(editingItem: item) { updatedName in
                        // update database
                        item.friendlyName = updatedName
                        CoreDataManager.shared.updatePDFHistory(item, updateAcces: false) { updated, error in
                                    if let error = error {
                                        print("Error: \(error)")
                                    } else if updated {
                                        print("Entry was updated in the database.")
                                    } else {
                                        print("Something else happened in the database.")
                                    }
                                }
                        self.editingItem = nil
                        self.loadHistory()
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
            Text("Document Name").bold().font(.largeTitle)
                .multilineTextAlignment(.leading)

            TextField("Name", text: $friendlyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding()
            
            Button("Save") {
                onDone(friendlyName)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }.padding()
    }
}

struct HistoryView_Previews: PreviewProvider {
  @State static var pdfURL: URL? = nil

  static var previews: some View {
    HistoryView(pdfURL: $pdfURL)
  }
}
