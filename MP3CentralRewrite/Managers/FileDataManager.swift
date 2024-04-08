//
//  FileDataManager.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 2/3/24.
//

import Foundation
class FileDataManager {
  
  @Published var persistenceController = PersistenceController.shared
  
  func deleteFile(_ songName: String) {
    let destinationUrl = self.getLocalUrlForName(name: songName)
    do {
      try FileManager.default.removeItem(at: destinationUrl)
      persistenceController.deleteFile(songName)
    } 
    catch let error as NSError {
      if !FileManager.default.fileExists(atPath: destinationUrl.relativePath) {
        persistenceController.deleteFile(songName)
      } else {
        // TODO: Handle Error (This would be a file access error)
      }
    }
  }
  
  func addFileAt(audioUrl: URL) {
    let fileName = audioUrl.lastPathComponent
    let destinationUrl = self.getLocalUrlForName(name: fileName)
    
    guard audioUrl.startAccessingSecurityScopedResource() else {
      // TODO: Handle Error
      return
    }
    
    if FileManager.default.fileExists(atPath: destinationUrl.path) {
      AppViewModel.shared.promptForRewrite(onYes: {
        self.rewrite(newUrl: audioUrl, oldUrl: destinationUrl)
      })
    } else {
      self.downloadFile(audioUrl: audioUrl, destinationUrl: destinationUrl)
    }
    
    audioUrl.stopAccessingSecurityScopedResource()
  }
  
  func getLocalUrlForName(name: String) -> URL {
    let destinationUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name)
    return destinationUrl
  }
  
  func rewrite(newUrl: URL, oldUrl: URL) {
    do {
      self.deleteFile(oldUrl.lastPathComponent)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.downloadFile(audioUrl: newUrl, destinationUrl: oldUrl)
      }
    } catch let error as NSError {
      // TODO: Handle Error
      print(error.localizedDescription)
    }
  }
  
  private func downloadFile(audioUrl: URL, destinationUrl: URL) {
    print("")
    guard audioUrl.startAccessingSecurityScopedResource() else {
      // TODO: Handle Error
      return
    }
    
    URLSession.shared.downloadTask(
      with: audioUrl,
      completionHandler: { location, _, error in
      self.handleFileDownload(location: location, error: error, destinationUrl: destinationUrl)
      audioUrl.stopAccessingSecurityScopedResource()
    }).resume()
  }
  
  private func handleFileDownload(location: URL?, error: Error?, destinationUrl: URL) {
    if let error = error {
      // TODO: Handle Error
      print(error.localizedDescription)
    }
    guard let location = location else { return }
    do {
      try FileManager.default.moveItem(at: location, to: destinationUrl)
      DispatchQueue.main.async {
        self.persistenceController.addFileFrom(url: destinationUrl)
      }
    }
    catch let error as NSError {
      // TODO: Handle Error
      print(error.localizedDescription)
    }
  }
}
