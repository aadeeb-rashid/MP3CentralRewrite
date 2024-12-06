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
        
        interfaceController.setRootTemplate(CarPlayHelloWorld().template, animated: false, completion: nil)
    }
    
    func templateApplicationScene(_ templateApplicationScene: CPTemplateApplicationScene, didDisconnectInterfaceController interfaceController: CPInterfaceController) {
    }
}
