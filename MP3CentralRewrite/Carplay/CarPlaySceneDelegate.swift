//
//  CarPlaySceneDelegate.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/6/24.
//


import Foundation
import CarPlay

class CarPlaySceneDelegate: UIResponder, CPTemplateApplicationSceneDelegate {
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didConnect interfaceController: CPInterfaceController) {
      let placeholder = CPListTemplate(title: "Loading...", sections: [])
      interfaceController.setRootTemplate(placeholder, animated: false) { _, _ in
        interfaceController.setRootTemplate(CarPlayLibraryView().template, animated: true, completion: nil)
      }
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
    }
}
