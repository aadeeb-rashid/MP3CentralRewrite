//
//  CarPlayLibraryView.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/6/24.
//

import Foundation
import CarPlay

class CarPlayLibraryView {
  var template: CPListTemplate {
    return CPListTemplate(title: "Library", sections: [self.section])
  }
  
  var items: [CPListItem] {
    return LibraryCache.shared.library.map { localFile in
      let item = CPListItem(text: localFile.name, detailText: nil, image: UIImage(systemName: "play.fill"))
      item.handler = { _, completion in
        self.onItemTapped(item: localFile)
        completion()
      }
      return item
    }
  }
  
  private var section: CPListSection {
    return CPListSection(items: items)
  }
  
  func onItemTapped(item: LocalFile) {
    guard let songName = item.name else {
      //TODO: Throw Carplay Error or Alert Here
      return
    }
    AppViewModel.shared.navigateToMusicPlayerScreen(songName: songName)
    CarPlayViewModel.shared?.showNowPlayingScreen()
  }
}
