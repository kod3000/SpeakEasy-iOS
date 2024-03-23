//
//  CoreDataManager.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/22/24.
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
        pdfHistory.friendlyName = url.relativeString
        pdfHistory.fileName = url.relativeString
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
    
    func addPDFURLIfNeeded(url: URL, completion: @escaping (Bool, Error?) -> Void) {
        
            if url.absoluteString == "" {
                return;
            }
            let context = persistentContainer.viewContext
            
            // Create request to PDFHistory entity, filter by the urlString
            let fetchRequest: NSFetchRequest<PDFHistory> = PDFHistory.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "urlString == %@", url.absoluteString)
            
            do {
                // Perform check for existing entries
                let results = try context.fetch(fetchRequest)
                
                if results.isEmpty {
                    // none in database, insert a new PDFHistory object
                    let newPDFHistory = PDFHistory(context: context)
                    newPDFHistory.urlString = url.absoluteString
                    newPDFHistory.access = Date()
                    newPDFHistory.friendlyName = url.relativeString
                    newPDFHistory.fileName = url.relativeString                    
                    try context.save()
                    completion(true, nil)
                } else {
                    // Not added because it already exists
                    completion(false, nil)
                }
            } catch {
                // Damn .. Error occurred
                completion(false, error)
            }
        }
    
}
