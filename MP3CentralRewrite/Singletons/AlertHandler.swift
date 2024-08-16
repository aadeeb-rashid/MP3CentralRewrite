//
//  AlertHandler.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/11/24.
//

import Foundation
import SwiftUI
class AlertHandler: ObservableObject {
  @Published private var alert : Alert? = nil
  var showAlert: Binding<Bool> {
    Binding<Bool>(
      get: { return self.alert != nil },
      set: { _ in
        self.alert = nil
      }
    )
  }
  
  static let shared = AlertHandler()
  
  func errorAlert() -> Alert {
    return self.alert ?? Alert(title: Text("Failed Task"))
  }
  
  func promptForRewrite(onYes : @escaping () -> Void) {
    let alert = Alert(
      title: Text("The file is already in your library. Would you like to replace it?"),
      primaryButton: .cancel(Text("No")),
      secondaryButton: .default(Text("Yes"), action: onYes))
    self.setAlert(alert)
  }

  func remindForNewSongWhilePlaying() {
    if AppViewModel.shared.audioManager.isPlaying {
      let alert = Alert(title: Text("File has been added, you will have to reset the music player (tap a song) to update the queue."))
      self.setAlert(alert)
    }
  }
  
  func remindForDeletedSongWhilePlaying() {
    if AppViewModel.shared.audioManager.isPlaying {
      let alert = Alert(title: Text("File has been deleted, you will have to reset the music player (tap a song) to update the queue."))
      self.setAlert(alert)
    }
  }
  
  func throwSecurityScopeError() {
    let alert = Alert(title: Text("We do not have proper access to the files neceeary, please reimport files or redownload app."))
    self.setAlert(alert)
  }
  
  private func setAlert(_ alert: Alert) {
    DispatchQueue.main.async {
      self.alert = alert
    }
  }
  
  func handleError(_ error: Error) {
    let alert = Alert(title: Text("\(error.localizedDescription)"))
    self.setAlert(alert)
  }
}
