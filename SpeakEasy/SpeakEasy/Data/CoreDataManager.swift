//
//  CoreDataManager.swift
//  SpeakEasy
//
//  Created by username on 3/22/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "PDFHistoryModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }

    func savePDFURL(url: URL, completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        let pdfHistory = PDFHistory(context: context)
        pdfHistory.urlString = url.absoluteString
        pdfHistory.access = Date()

        do {
            try context.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func fetchPDFHistory() -> [PDFHistory] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PDFHistory> = PDFHistory.fetchRequest()

        // lets sort by access date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "access", ascending: false)]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch PDFHistory: \(error)")
            return []
        }
    }
}
