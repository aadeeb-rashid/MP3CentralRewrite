//
//  PlayerModeProtocol.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 5/4/24.
//

import Foundation
protocol PlayerQueueProtocol {
  var currentSong : LocalFile { get set }
  var queue: [LocalFile] { get set }
  
  func nextSong() -> LocalFile
  func previousSong() -> LocalFile
  func setCurrentSong(_ song: LocalFile) 
}
