//
//  CurrentSongWidget.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 8/16/24.
//

import SwiftUI

struct CurrentSongWidget: View {
  @ObservedObject var audioManager: AudioManager
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("Now Playing: ")
          .font(Font.custom("Play", size: 10))
          .foregroundStyle(.red)
          .bold()
        
        Text(audioManager.queueManager?.currentSong().name ?? "Test.mp3")
          .font(Font.custom("Play", size: 20))
          .foregroundStyle(.white)
          .bold()
        
      }
      
      Spacer()
      
      Button(action: {
        self.audioManager.playPause()
      }, label: {
        getPlayPauseButtonImage()
      })
    }
    .padding(10)
    .background(.black)
    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
    .padding(.horizontal, 5)
  }
  
  func getPlayPauseButtonImage() -> some View {
    Image(systemName: getPlayPauseButtonImageName())
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundColor(.white)
      .frame(width: 25, height: 25, alignment: .leading)
  }
  
  func getPlayPauseButtonImageName() -> String {
    self.audioManager.isPlaying ? "pause.fill" : "play.fill"
  }
}

#Preview {
  CurrentSongWidget(audioManager: AppViewModel.shared.audioManager)
}
