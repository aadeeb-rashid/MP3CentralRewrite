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
      CPListItem(text: localFile.name, detailText: nil, image: UIImage(systemName: "play.fill")?.withTintColor(.black))
    }
  }
  
  private var section: CPListSection {
    return CPListSection(items: items)
  }
}
