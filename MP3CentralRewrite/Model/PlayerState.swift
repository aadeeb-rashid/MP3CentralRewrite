//
//  PlayerState.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/8/24.
//

import Foundation
enum PlayerState {
  case libraryMode
  case shuffleMode
  case repeatMode
  case repeatShuffleMode
  
  func repeatTapped() -> PlayerState {
    switch self {
      case .libraryMode:
        return .repeatMode
      case .shuffleMode:
        return .repeatShuffleMode
      case .repeatMode:
        return .libraryMode
      case .repeatShuffleMode:
        return .shuffleMode
    }
  }
  
  func shuffleTapped() -> PlayerState {
    switch self {
      case .libraryMode:
        return .shuffleMode
      case .shuffleMode:
        return .libraryMode
      case .repeatMode:
        return .repeatShuffleMode
      case .repeatShuffleMode:
        return .repeatMode
    }
  }
  
  func getPlayerQueue(currentSong: LocalFile, queue: [LocalFile]) -> PlayerQueueProtocol {
    switch self {
      case .libraryMode:
        return LibraryQueue(currentSong: currentSong, queue: queue)
      case .shuffleMode:
        return ShuffleQueue(currentSong: currentSong, queue: queue)
      case .repeatMode:
        return RepeatQueue(currentSong: currentSong, queue: queue)
      case .repeatShuffleMode:
        return RepeatQueue(currentSong: currentSong, queue: queue)
    }
  }
  
}
