//
//  RepeatQueue.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/4/24.
//

import Foundation
import SwiftUI
class RepeatQueue : PlayerQueueProtocol {
  
  @Published var currentSong: LocalFile
  internal var queue: [LocalFile]
  
  init(currentSong: LocalFile, queue: [LocalFile]) {
    self.currentSong = currentSong
    self.queue = queue
  }
  
  func nextSong() -> LocalFile {
    return currentSong
  }
  
  func previousSong() -> LocalFile {
    return currentSong
  }
  
  func setCurrentSong(_ song: LocalFile) {
    withAnimation {
      self.currentSong = song
    }
  }
}
