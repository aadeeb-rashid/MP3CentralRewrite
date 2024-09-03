//
//  SongCenterView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/9/24.
//

import SwiftUI

struct SongCenterView: View {
  
  @ObservedObject var audioManager = AppViewModel.shared.audioManager
  var shuffleMode: Bool { audioManager.queueManager?.state == .shuffleMode || audioManager.queueManager?.state == .repeatShuffleMode}
  var repeatMode: Bool { audioManager.queueManager?.state == .repeatMode || audioManager.queueManager?.state == .repeatShuffleMode}
  
  var body: some View {
    
    VStack {
      
      Text(audioManager.queueManager?.currentSong().name ?? "Corrupted File")
        .animation(.easeInOut, value: audioManager.queueManager?.currentSong().name)
        .multilineTextAlignment(.center)
        .font(Font.custom("Play", size: 25))
        .foregroundStyle(Color.black)
        .bold()
        .padding(.top, 20)

      shuffleAndRepeatButtons()
        .padding(.horizontal, 20)
        .padding(.top, 20)
      
      SongCenterSlider(value: $audioManager.songCurrentPosition) {
        audioManager.seekToTime()
      }
        .padding(.horizontal, 20)
      
      timerLabels()
        .padding(.horizontal, 20)
        .padding(.top, -15)
      
      musicPlayerButtons()
        .padding(.top, 20)
        .padding(.horizontal, 40)
        .padding(.bottom, 10)
      
    }
    .padding(.vertical, 5)
    .frame(minWidth: 350)
    .background(background())
    .background(.clear)
    .padding(.horizontal, 20)
  }
  
  func background() -> some View {
    RoundedRectangle(cornerRadius: 30)
      .fill(Color.white)
      .overlay(
        RoundedRectangle(cornerRadius: 30)
          .stroke(Color.black, lineWidth: 3)
          .foregroundColor(.clear)
      )
  }
}

#Preview {
  SongCenterView()
}
