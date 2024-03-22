//
//  LocalFilesView.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/20/24.
//

import SwiftUI

// TODO: We need to allow the user to select the
// file they want to load int
// We need to allow the user to select the file they want to load int
struct DocumentPicker: UIViewControllerRepresentable {
    var onDocumentPicked: (URL) -> Void
        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // Not used in this context
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ documentPicker: DocumentPicker) {
            self.parent = documentPicker
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onDocumentPicked(url)
        }
    }
}
struct LocalFilesView: View {
        @State private var showingDocumentPicker = false
        
        var body: some View {
            Button("Select PDF") {
                showingDocumentPicker = true
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker { url in
                    print("Selected document at \(url)")
                    // Here you could do something with the selected PDF file URL
                }
            }
        }
}

struct LocalFilesView_Previews: PreviewProvider {
    static var previews: some View {
        LocalFilesView()
    }
}
