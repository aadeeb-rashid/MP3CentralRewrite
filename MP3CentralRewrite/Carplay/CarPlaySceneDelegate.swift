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
      CarPlayViewModel.shared = CarPlayViewModel(interfaceController: interfaceController)
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
      CarPlayViewModel.shared = nil
    }
}
