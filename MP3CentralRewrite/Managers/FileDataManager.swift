//
//  FileDataManager.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 2/3/24.
//

import Foundation
class FileDataManager {
  
  private let libraryCache = LibraryCache.shared
  private let alertHandler = AlertHandler.shared
  
  private func getLocalUrlForName(name: String) -> URL {
    let destinationUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(name)
    return destinationUrl
  }
  
  func deleteFile(_ songName: String) {
    let destinationUrl = self.getLocalUrlForName(name: songName)
    
    do {
      self.libraryCache.deleteFile(songName)
      try FileManager.default.removeItem(at: destinationUrl)
    }
    catch let error as NSError {
      AlertHandler.shared.handleError(error)
    }
  }
  
  func addFileAt(audioUrl: URL) {
    let fileName = audioUrl.lastPathComponent
    let destinationUrl = self.getLocalUrlForName(name: fileName)
    
    guard audioUrl.startAccessingSecurityScopedResource() else {
      AlertHandler.shared.throwSecurityScopeError()
      return
    }
    
    if FileManager.default.fileExists(atPath: destinationUrl.path) {
      self.alertHandler.promptForRewrite(onYes: {
        self.rewrite(newUrl: audioUrl, oldUrl: destinationUrl)
      })
    } else {
      self.downloadFile(audioUrl: audioUrl, destinationUrl: destinationUrl)
    }
    
    audioUrl.stopAccessingSecurityScopedResource()
  }
  
  func rewrite(newUrl: URL, oldUrl: URL) {
    do {
      self.deleteFile(oldUrl.lastPathComponent)
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.downloadFile(audioUrl: newUrl, destinationUrl: oldUrl)
      }
    }
  }
  
  private func downloadFile(audioUrl: URL, destinationUrl: URL) {
    guard audioUrl.startAccessingSecurityScopedResource() else {
      AlertHandler.shared.throwSecurityScopeError()
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
      AlertHandler.shared.handleError(error)
      return
    }
    guard let location = location else { return }
    
    do {
      try FileManager.default.moveItem(at: location, to: destinationUrl)
      self.libraryCache.addFile(destinationUrl.lastPathComponent)
    }
    catch let error as NSError {
      AlertHandler.shared.handleError(error)
    }
  }
}
