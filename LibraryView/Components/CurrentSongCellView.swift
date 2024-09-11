//
//  CurrentSongCellView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 9/9/24.
//

import SwiftUI
import Marquee

struct CurrentSongCellView: View {
  
  @ObservedObject var audioManager: AudioManager
  
  init(audioManager: AudioManager) {
    self.audioManager = audioManager
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("Now Playing: ")
          .font(Font.custom("Play", size: 12))
          .foregroundStyle(.red)
          .bold()
          .lineLimit(1)
          .truncationMode(.tail)
          .padding(.leading, 25)
        
        Marquee {
          Text(audioManager.queueManager?.currentSong().name ?? "Test.mp3")
            .font(Font.custom("Play", size: 25))
            .foregroundStyle(.white)
            .bold()
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.bottom, 5)
            .padding(.top, -5)
            
        }
        .marqueeDuration(5)
        .padding(.leading, 17)
        .frame(height: 40)
      }
      
      Spacer()
      
      Button(action: {
        self.audioManager.playPause()
      }, label: {
        getPlayPauseButtonImage()
      })
      
    }
    .padding(.vertical, 6)
    .frame(minWidth: 350)
    .background(background())
    .background(.clear)
    .padding(.horizontal, 10)
    .padding(12.5)
  }
  
  func background() -> some View {
    RoundedRectangle(cornerRadius: 50)
      .fill(Color.black)
  }
  
  func getPlayPauseButtonImage() -> some View {
    Image(systemName: getPlayPauseButtonImageName())
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(.red)
      .frame(width: 44, height: 44)
      .padding(.trailing, 10)
  }
  
  func getPlayPauseButtonImageName() -> String {
    self.audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill"
  }
}

#Preview {
  CurrentSongCellView(audioManager: AppViewModel.shared.audioManager)
}
