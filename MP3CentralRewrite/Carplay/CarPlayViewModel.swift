//
//  CarPlayViewModel.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/6/24.
//

import CarPlay

class CarPlayViewModel {
  static var shared : CarPlayViewModel? = nil
  var interfaceController: CPInterfaceController
  
  init(interfaceController: CPInterfaceController) {
    self.interfaceController = interfaceController
    showLibrary()
  }
  
  func showLibrary() {
    self.interfaceController.setRootTemplate(CarPlayLibraryView().template, animated: true, completion: nil)
  }
  
  func showNowPlayingScreen() {
    self.interfaceController.pushTemplate(CPNowPlayingTemplate.shared, animated: true) { _, error in
      if let error = error {
        //TODO: Throw Carplay Error or Alert
        return
      }
    }
  }
}
