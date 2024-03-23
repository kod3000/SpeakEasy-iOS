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
    
    var body: some Scene {
          WindowGroup {
              ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
          }
      }
}
