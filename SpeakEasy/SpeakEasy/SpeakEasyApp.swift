//
//  SpeakEasyApp.swift
//  SpeakEasy
//
//  Created by Nestor Rivera (aka dany) on 3/19/24.
//

import SwiftUI
import AVFoundation
import CoreData

@main
struct SpeakEasyApp: App {
    
    let persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "PDFHistoryModel")
         container.loadPersistentStores { storeDescription, error in
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         }
         return container
     }()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
