//
//  MusicPlayerView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/9/24.
//

import SwiftUI

struct MusicPlayerView: View {
  @Binding var showMusicPlayer: Bool
  
  let VERTICAL_PADDING : CGFloat = 45.0
  
  var body: some View {
    ZStack {
      
      background()
      
      VStack(alignment: .leading) {
        
        backButton()
        
        Spacer()
        
        SongCenterView()
          .padding(.bottom, VERTICAL_PADDING + 20)
        
        Spacer()
        
      }
    }
  }
  
  func background() -> some View {
    Image("MusicPlayerBackground")
      .resizable()
      .aspectRatio(contentMode: .fill)
      .ignoresSafeArea()
  }
  
  func backButton() -> some View {
    Button(action: {
      self.showMusicPlayer = false
    }, label: {
      Text("< Your Library")
        .font(Font.custom("Play", size: 25))
        .foregroundStyle(.black)
        .bold()
        .padding(.top, VERTICAL_PADDING)
        .padding(.leading, 25)
    })
  }
  
}

#Preview {
  MusicPlayerView(showMusicPlayer: Binding(get: {return true}, set: {_ in }))
}
