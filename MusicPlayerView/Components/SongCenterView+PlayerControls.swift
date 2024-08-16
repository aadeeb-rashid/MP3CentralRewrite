//
//  SongCenterView+PlayerControls.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/25/24.
//

import Foundation
import SwiftUI

extension SongCenterView {
  func musicPlayerButtons() -> some View {
    HStack {
      
      Button(action: {
        self.audioManager.rewind()
      }, label: {
        getRewindButtonImage()
      })
      
      Spacer()
      
      Button(action: {
        self.audioManager.playPause()
      }, label: {
        getPlayPauseButtonImage()
      })
      
      Spacer()
      
      Button(action: {
        self.audioManager.forward()
      }, label: {
        getForwardButtonImage()
      })
      
    }
  }
  
  func getRewindButtonImage() -> some View {
    Image("MusicPlayerRewind")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 44, height: 42, alignment: .leading)
      .shadow(radius: 5, y: 7)
  }
  
  func getForwardButtonImage() -> some View {
    Image("MusicPlayerForward")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 44, height: 42, alignment: .leading)
      .shadow(radius: 5, y: 7)
  }
  
  func getPlayPauseButtonImage() -> some View {
    Image(getPlayPauseButtonImageName())
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 65, height: 65, alignment: .leading)
      .shadow(radius: 5, y: 5)
  }
  
  func getPlayPauseButtonImageName() -> String {
    self.audioManager.isPlaying ? "MusicPlayerPause" : "MusicPlayerPlay"
  }
}
