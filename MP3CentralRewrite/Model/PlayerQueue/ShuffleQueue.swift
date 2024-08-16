//
//  ShuffleQueue.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/4/24.
//

import Foundation
import SwiftUI
class ShuffleQueue : PlayerQueueProtocol {
  
  @Published var currentSong : LocalFile
  internal var queue: [LocalFile]
  
  init(currentSong: LocalFile, queue: [LocalFile]) {
    self.queue = queue
    self.currentSong = currentSong
    self.queue.shuffle()
  }
  
  func nextSong() -> LocalFile {
    self.queue.append(self.currentSong)
    self.setCurrentSong(self.queue.removeFirst())
    return self.currentSong
  }
  
  func previousSong() -> LocalFile {
    self.queue.insert(self.currentSong, at: 0)
    self.setCurrentSong(self.queue.removeLast())
    return self.currentSong
  }
  
  func setCurrentSong(_ song: LocalFile) {
    withAnimation {
      self.currentSong = song
    }
  }
}
