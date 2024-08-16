//
//  SongListView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/22/24.
//

import SwiftUI

struct SongListView : View {
  @ObservedObject var viewModel : AppViewModel
  @ObservedObject private var libraryCache = LibraryCache.shared
  
  var body: some View {
    ScrollView {
      
      AddCellView(viewModel: viewModel)
      
      ForEach(libraryCache.library, id: \.self) {
        song in
        
        SongCellView(song.name ?? "File Corrupted", viewModel: viewModel)
      }
    }
    .animation(.easeInOut, value: libraryCache.library)
  }
  
  init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }
}

#Preview {
  SongListView(viewModel: AppViewModel.shared)
}
