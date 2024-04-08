//
//  SongCenterSlider.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 1/15/24.
//

import Foundation
import SwiftUI
struct SongCenterSlider: UIViewRepresentable {
  @Binding var value: Double
  
  class Coordinator: NSObject {
    var value: Binding<Double>
    
    init(value: Binding<Double>) {
      self.value = value
    }
    
    @objc func valueChanged(_ sender: UISlider) {
      self.value.wrappedValue = Double(sender.value)
    }
  }
  
  func makeCoordinator() -> SongCenterSlider.Coordinator {
    Coordinator(value: $value)
  }
  
  func makeUIView(context: Context) -> UISlider {
    let slider = UISlider(frame: .zero)
    slider.thumbTintColor = .clear
    slider.minimumTrackTintColor = .black
    slider.maximumTrackTintColor = .gray
    slider.minimumValue = Float(0.00)
    slider.maximumValue = Float(1.00)
    slider.value = Float(value)
    
    slider.addTarget(
      context.coordinator,
      action: #selector(Coordinator.valueChanged(_:)),
      for: .valueChanged
    )
    
    return slider
  }
  
  func updateUIView(_ uiView: UISlider, context: Context) {
    uiView.value = Float(value)
  }
}
