//
//  SongCellView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/5/23.
//

import SwiftUI

struct SongCellView: View {
  
  @ObservedObject var viewModel : AppViewModel
  var songName: String
  
  init(_ songName: String, viewModel: AppViewModel) {
    self.songName = songName
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      
      Button(action: {
        viewModel.deleteSong(songName)
      }, label: {
        trashButtonImage()
      })
      
      Text(songName)
        .font(Font.custom("Play", size: 25))
        .foregroundStyle(Color.black)
        .lineLimit(1)
        .truncationMode(.tail)
      
      Spacer()
      
      Button(action: {
        viewModel.navigateToMusicPlayerScreen(songName: songName)
      }, label: {
        playButtonImage()
      })
      
    }
    .padding(.vertical, 6)
    .frame(minWidth: 350)
    .background(background())
    .background(.clear)
    .padding(.horizontal, 10)
    .padding(12.5)
    .onTapGesture {
      viewModel.navigateToMusicPlayerScreen(songName: songName)
    }
  }
  
  func background() -> some View {
    RoundedRectangle(cornerRadius: 50)
      .fill(Color.white)
      .overlay(
        RoundedRectangle(cornerRadius: 50)
          .stroke(Color.black, lineWidth: 2)
          .foregroundColor(.clear)
      )
  }
  
  func trashButtonImage() -> some View {
    Image(systemName: "trash.fill")
      .resizable()
      .foregroundStyle(.black)
      .frame(width: 30, height: 32)
      .padding(.leading)
  }
  
  func playButtonImage() -> some View {
    Image(systemName: "play.circle.fill")
      .resizable()
      .foregroundStyle(.black)
      .frame(width: 44, height: 44)
      .padding(.trailing, 10)
  }
}

#Preview {
  SongCellView("Song Title.mp3", viewModel: AppViewModel.shared)
}
