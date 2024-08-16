//
//  LibraryCache.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/3/24.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class LibraryCache: ObservableObject {
  @Published var library: [LocalFile] = LibraryCache.loadLibrary()
  
  static let shared = LibraryCache()
  static var persistenceManager = PersistenceManager()
  
  private static func loadLibrary() -> [LocalFile] {
    let fetchRequest: NSFetchRequest<LocalFile> = LocalFile.fetchRequest()
    do {
      return try persistenceManager.getContext().fetch(fetchRequest)
    } catch let error as NSError {
      AlertHandler.shared.handleError(error)
      return []
    }
  }
  
  func addFile(_ name: String) {
    let context : NSManagedObjectContext = LibraryCache.persistenceManager.getContext()
    let entity = LocalFile(context: context)
    entity.name = name
    
    DispatchQueue.main.async {
      self.library.append(entity)
      LibraryCache.persistenceManager.save()
    }
    
    AlertHandler.shared.remindForNewSongWhilePlaying()
  }
  
  func deleteFile(_ fileName: String) {
    self.library.removeAll(where: { $0.name == fileName })
    LibraryCache.persistenceManager.deleteFile(fileName)
    AlertHandler.shared.remindForDeletedSongWhilePlaying()
  }
}
