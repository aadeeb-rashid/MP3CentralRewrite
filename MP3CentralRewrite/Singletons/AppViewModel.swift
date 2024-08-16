//
//  AppViewModel.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/10/24.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class AppViewModel : ObservableObject {
  
  @Published var willImportFile : Bool = false
  @Published var fileDataManager : FileDataManager = FileDataManager()
  @ObservedObject var audioManager : AudioManager = AudioManager()
  
  @Published var musicPlayerScreenVisible : Bool = false
  
  static var shared : AppViewModel = AppViewModel()
  
  func deleteSong(_ songName : String) {
    self.fileDataManager.deleteFile(songName)
  }
  
  func addNewSong() {
    DispatchQueue.main.async {
      self.willImportFile = true
    }
  }
  
  func onFileImportComplete(result : Result<URL, Error>) {
    switch result {
      case .success(let songUrl):
        self.fileDataManager.addFileAt(audioUrl: songUrl)
        break
      case .failure(let error):
        AlertHandler.shared.handleError(error)
        break
    }
  }
  
  func navigateToMusicPlayerScreen(songName : String) {
    guard let songIndex = LibraryCache.shared.library.firstIndex(where: {$0.name == songName}) else { return }
    let currentSong = LibraryCache.shared.library[songIndex]
    
    var queue = LibraryCache.shared.library
    queue.remove(at: songIndex)
    
    if songIndex < queue.count {
      let slice = queue.prefix(songIndex)
      queue.removeFirst(songIndex)
      queue.append(contentsOf: slice)
    }
    
    self.audioManager.setFirstQueue(QueueManager(currentSong: currentSong, queue: queue))
    self.musicPlayerScreenVisible = true
  }
}
