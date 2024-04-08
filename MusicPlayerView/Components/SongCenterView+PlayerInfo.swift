//
//  SongCenterView+PlayerInfo.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/25/24.
//

import Foundation
import SwiftUI

extension SongCenterView {

  func shuffleAndRepeatButtons() -> some View {
    HStack {
      Button(action: {
        self.appViewModel.audioManager.shuffleButtonPressed()
      }, label: {
        shuffleButtonImage()
      })
      
      Spacer()
      
      Button(action: {
        appViewModel.audioManager.repeatButtonPressed()
      }, label: {
        repeatButtonImage()
      })
    }
  }
  
  func timerLabels() -> some View {
    HStack {
      Text("0:00")
        .font(Font.custom("Play", size: 14))
        .foregroundStyle(Color.black)
      
      Spacer()
      
      Text("12:00")
        .font(Font.custom("Play", size: 14))
        .foregroundStyle(Color.black)
    }
  }
  
  func shuffleButtonImage() -> some View {
    Image(getShuffleButtonImageName())
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 33, height: 33, alignment: .leading)
  }
  
  func getShuffleButtonImageName() -> String {
    appViewModel.audioManager.shuffleMode ? "MusicPlayerShuffleOn" : "MusicPlayerShuffleOff"
  }
  
  func repeatButtonImage() -> some View {
    Image(getRepeatButtonImageName())
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: 35, height: 35, alignment: .leading)
  }
  
  func getRepeatButtonImageName() -> String {
    appViewModel.audioManager.repeatMode ? "MusicPlayerRepeatOn" : "MusicPlayerRepeatOff"
  }
}
