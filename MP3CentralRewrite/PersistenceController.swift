//
//  PersistanceController.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 2/3/24.
//

import Foundation
import CoreData
import Swift
struct PersistenceController {
  
  // A singleton for our entire app to use
  static let shared = PersistenceController()
  
  // Storage for Core Data
  let container: NSPersistentContainer
  
  // A test configuration for SwiftUI previews
  static var preview: PersistenceController = {
    let controller = PersistenceController(inMemory: true)
    
    // Create 10 example
    for _ in 0..<10 {
      let song = LocalFile(context: controller.getContext())
      song.name = "Song 1.mp3"
    }
    
    return controller
  }()
  
  // An initializer to load Core Data, optionally able to use an in-memory store.
  init(inMemory: Bool = false) {
    // If you didn't name your model Main you'll need to change this name below.
    container = NSPersistentContainer(name: "Main")
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func getContext() -> NSManagedObjectContext {
    return self.container.viewContext
  }
  
  func save() {
    let context = getContext()
    
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Show some error here
      }
    }
  }
  
  func addFileFrom(url : URL) {
    let name = url.lastPathComponent
    let context : NSManagedObjectContext = self.getContext()
    let entity = LocalFile(context: context)
    entity.name = name
    self.save()
  }
  
  func deleteFile(_ songName : String) {
    let context = getContext()
    
    let fetchRequest: NSFetchRequest<LocalFile> = LocalFile.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "name == %@", songName)
    
    do {
      let matchingEntities = try context.fetch(fetchRequest)
      
      for entity in matchingEntities {
        context.delete(entity)
      }
      
      try context.save()
    } catch {
      //TODO: Handle Error
    }
  }
}
