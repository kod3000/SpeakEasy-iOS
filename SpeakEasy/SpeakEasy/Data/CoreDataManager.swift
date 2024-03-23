//
//  CoreDataManager.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/22/24.
//

import CoreData
import Foundation

class CoreDataManager {
  static let shared = CoreDataManager()
  let persistentContainer: NSPersistentContainer

  init() {
    persistentContainer = NSPersistentContainer(name: "PDFHistoryModel")
    persistentContainer.loadPersistentStores { (_, error) in
      if let error = error {
        fatalError("Core Data Store failed \(error.localizedDescription)")
      }
    }
  }

  private var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  func savePDFURL(url: URL, completion: @escaping (Bool, Error?) -> Void) {
    guard !url.absoluteString.isEmpty else {
      // No error, just no action taken for empty URL.
      completion(false, nil)
      return
    }

    context.perform {
      if self.fetchPDFHistory(with: url.absoluteString).isEmpty {
        let pdfHistory = PDFHistory(context: self.context)
        pdfHistory.urlString = url.absoluteString
        pdfHistory.friendlyName = url.lastPathComponent
        pdfHistory.fileName = url.standardizedFileURL.lastPathComponent
        pdfHistory.access = Date()

        do {
          try self.context.save()
          completion(true, nil)
        } catch {
          completion(false, error)
        }
      } else {
        // No error, just no need to add a duplicate.
        completion(false, nil)
      }
    }
  }

  func deletePDFHistory(_ pdfHistory: PDFHistory, completion: @escaping (Bool, Error?) -> Void) {
    context.perform {
      self.context.delete(pdfHistory)

      do {
        try self.context.save()
        completion(true, nil)
      } catch {
        completion(false, error)
      }
    }
  }

  func updatePDFHistory(_ pdfHistory: PDFHistory, completion: @escaping (Bool, Error?) -> Void) {
    context.perform {
      pdfHistory.access = Date()

      do {
        try self.context.save()
        completion(true, nil)
      } catch {
        completion(false, error)
      }
    }
  }

  func fetchPDFHistory() -> [PDFHistory] {
    let fetchRequest: NSFetchRequest<PDFHistory> = PDFHistory.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "access", ascending: false)]

    do {
      return try context.fetch(fetchRequest)
    } catch {
      print("Failed to fetch PDFHistory: \(error)")
      return []
    }
  }

  private func fetchPDFHistory(with urlString: String) -> [PDFHistory] {
    let fetchRequest: NSFetchRequest<PDFHistory> = PDFHistory.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "urlString == %@", urlString)

    do {
      return try context.fetch(fetchRequest)
    } catch {
      print("Error fetching PDFHistory for URL: \(error)")
      return []
    }
  }
}
