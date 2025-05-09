//
//  CarPlayViewModel.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/6/24.
//

import CarPlay

class CarPlayViewModel {
  //TODO: Fix NowPlaying Screen being broken if app is open
  //TODO: FIx NowPlaying Screen not "Playing" when song is tapped
  //TODO: Fix Repeat and Shuffle Buttons not being auto-set if app is open
  //TODO: Fix Previous and Next Buttons only going in order and not using shuffle or repeat queues
  //TODO: Make custom screen(s)
  
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
    self.interfaceController.pushTemplate(self.getNowPlayingTemplate(), animated: true) { _, error in
      if let error = error {
        //TODO: Throw Carplay Error or Alert
        return
      }
    }
  }
  
  private func getNowPlayingTemplate() -> CPNowPlayingTemplate {
    let nowPlayingTemplate = CPNowPlayingTemplate.shared
    
    let shuffleButton = CPNowPlayingShuffleButton { button in
      AppViewModel.shared.audioManager.shuffleButtonPressed()
    }
    shuffleButton.isSelected = AppViewModel.shared.audioManager.isShuffle()
    
    let repeatButton = CPNowPlayingRepeatButton { button in
      AppViewModel.shared.audioManager.repeatButtonPressed()
    }
    repeatButton.isSelected = AppViewModel.shared.audioManager.isRepeat()
    
    nowPlayingTemplate.updateNowPlayingButtons([shuffleButton, repeatButton])
    
    return nowPlayingTemplate
  }
}
