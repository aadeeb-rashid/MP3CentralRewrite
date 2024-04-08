//
//  LibraryView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/5/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
  
  @ObservedObject var viewModel : AppViewModel = AppViewModel.shared
  
  var body: some View {
    NavigationView {
      
      ZStack {
        
        NavigationLink(
          destination: MusicPlayerView().navigationBarBackButtonHidden(),
          isActive: $viewModel.musicPlayerScreenVisible
        ) {}
        
        background()
        
        VStack {
          
          Text("Your Library")
            .font(Font.custom("Play", size: 35))
            .foregroundStyle(Color.black)
            .bold()
            .padding(.vertical, 25)
          
          SongListView(viewModel: viewModel)
          
        } // VStack
      } // ZStack
      .fileImporter(isPresented: $viewModel.willImportFile, allowedContentTypes: [UTType.audio], onCompletion: viewModel.onFileImportComplete(result:))
      .alert(isPresented: $viewModel.showAlert) {
        viewModel.getCurrentAlert()
      }
    } // NavView
  }
  
  func background() -> some View {
    LinearGradient(colors: [.white, Color("LibraryBackgroundGreen"), Color("LibraryBackgroundPurple")], startPoint: .top, endPoint: .bottom)
      .ignoresSafeArea()
  }
}

#Preview {
  LibraryView()
}
