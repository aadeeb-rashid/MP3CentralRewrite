//
//  SongListView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/22/24.
//

import SwiftUI

struct SongListView : View {
  @ObservedObject var viewModel : AppViewModel
  
  var body: some View {
    ScrollView {
      
      AddCellView(viewModel: viewModel)
      
      ForEach(viewModel.audioManager.library, id: \.self) {
        song in
        
        SongCellView(song.name ?? "File Corrupted", viewModel: viewModel)
      }
    }
  }
  
  init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }
}

#Preview {
  SongListView(viewModel: AppViewModel.shared)
}
