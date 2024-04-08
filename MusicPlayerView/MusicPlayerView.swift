//
//  MusicPlayerView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/9/24.
//

import SwiftUI

struct MusicPlayerView: View {
  @Environment(\.presentationMode) var presentationMode
  
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
      presentationMode.wrappedValue.dismiss()
    }, label: {
      Text("< Your Library")
        .font(Font.custom("Play", size: 24))
        .foregroundStyle(.black)
        .bold()
        .frame(height: 20)
        .padding(.top, VERTICAL_PADDING)
        .padding(.leading, 10)
    })
  }
  
}

#Preview {
  MusicPlayerView()
}
