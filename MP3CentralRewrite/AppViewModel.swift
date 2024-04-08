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
  @Published var audioManager : AudioManager = AudioManager()
  
  @Published var musicPlayerScreenVisible : Bool = false
  
  @Published var showAlert : Bool = false
  private var alert : Alert?
  
  static var shared : AppViewModel = AppViewModel()
  
  func deleteSong(_ songName : String) {
    fileDataManager.deleteFile(songName)
  }
  
  func addNewSong() {
    willImportFile = true
  }
  
  func onFileImportComplete(result : Result<URL, Error>) {
    switch result {
      case .success(let songUrl):
        fileDataManager.addFileAt(audioUrl: songUrl)
        break
      case .failure(let error):
        self.alert = Alert(title: Text(error.localizedDescription))
        break
    }
  }
  
  func promptForRewrite(onYes : @escaping () -> Void) {
    let alert = Alert(
      title: Text("The file is already in your library. Would you like to replace it?"),
      primaryButton: .cancel(Text("No")),
      secondaryButton: .default(Text("Yes"), action: onYes))
    self.alert = alert
    self.showAlert = true
  }
  
  func getCurrentAlert() -> Alert {
    return self.alert ?? Alert(title: Text("Failed Task"))
  }
  
  func navigateToMusicPlayerScreen(songName : String) {
    guard let songIndex = self.audioManager.library.firstIndex(where: {$0.name == songName}) else { return }
    self.audioManager.songIndex = songIndex
    self.audioManager.prepareToPlay()
    self.musicPlayerScreenVisible = true
  }
}
