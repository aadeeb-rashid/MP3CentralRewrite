//
//  LibraryView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/5/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
  
  @ObservedObject var viewModel: AppViewModel
  @ObservedObject var alertHandler: AlertHandler = AlertHandler.shared
  
  init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      
      titleText()
      
      SongListView(viewModel: viewModel)
      
    }
    .background(background())
    .fileImporter(isPresented: $viewModel.willImportFile, allowedContentTypes: [UTType.audio], onCompletion: viewModel.onFileImportComplete(result:))
    .alert(isPresented: alertHandler.showAlert) {
      alertHandler.errorAlert()
    }
    .navigationDestination(isPresented: $viewModel.musicPlayerScreenVisible) {
      MusicPlayerView(showMusicPlayer: $viewModel.musicPlayerScreenVisible)
        .navigationBarBackButtonHidden()
    }
  }
  
  func background() -> some View {
    LinearGradient(colors: [.white, Color("LibraryBackgroundGreen"), Color("LibraryBackgroundPurple")], startPoint: .top, endPoint: .bottom)
      .ignoresSafeArea()
  }
  
  func titleText() -> some View {
    Text("Your Library")
      .font(Font.custom("Play", size: 35))
      .foregroundStyle(Color.black)
      .bold()
      .padding(.vertical, 25)
  }
}

#Preview {
  LibraryView(viewModel: AppViewModel.shared)
}
