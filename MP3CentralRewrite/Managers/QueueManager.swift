//
//  QueueManager.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/8/24.
//

import Foundation
class QueueManager {
  @Published var state: PlayerState
  var queue: PlayerQueueProtocol
  
  init(state: PlayerState = .libraryMode, currentSong: LocalFile, queue: [LocalFile]) {
    self.state = state
    self.queue = state.getPlayerQueue(currentSong: currentSong, queue: queue)
  }
  
  func nextSong() -> LocalFile {
    queue.nextSong()
  }
  
  func previousSong() -> LocalFile {
    queue.previousSong()
  }
  
  func currentSong() -> LocalFile {
    queue.currentSong
  }
  
  func isShuffle() -> Bool {
    return state == .shuffleMode || state == .repeatShuffleMode
  }
   
  func shuffleTapped() {
    self.state = self.state.shuffleTapped()
    reloadQueue()
  }
  
  func isRepeat() -> Bool {
    return state == .repeatMode || state == .repeatShuffleMode
  }
  
  func repeatTapped() {
    self.state = self.state.repeatTapped()
    reloadQueue()
  }
  
  private func reloadQueue() {
    self.queue = self.state.getPlayerQueue(currentSong: self.queue.currentSong, queue: self.queue.queue)
  }
  
}
