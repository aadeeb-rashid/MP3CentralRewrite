//
//  AddCellView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/5/24.
//

import SwiftUI

struct AddCellView: View {
  
  @ObservedObject var viewModel : AppViewModel
  
  init(viewModel: AppViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    HStack {
      
      Text("Add Song")
        .font(Font.custom("Play", size: 25))
        .foregroundStyle(Color.black)
        .lineLimit(1)
        .truncationMode(.tail)
        .padding(.leading, 15)
      
      Spacer()
      
      addButtonImage()
      
    }
    .padding(.vertical, 6)
    .frame(minWidth: 350)
    .background(background())
    .background(.clear)
    .padding(.horizontal, 10)
    .padding(12.5)
    .onTapGesture {
      viewModel.addNewSong()
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
  
  func addButtonImage() -> some View {
    Image(systemName: "plus.app")
      .resizable()
      .foregroundStyle(.black)
      .background(.clear)
      .frame(width: 40, height: 40)
      .padding(.trailing, 13)
  }
}

#Preview {
  AddCellView(viewModel: AppViewModel.shared)
}
