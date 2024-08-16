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
  var onValueChanged: () -> Void
  
  class Coordinator: NSObject {
    var value: Binding<Double>
    var onValueChanged: () -> Void
    
    init(value: Binding<Double>, onValueChanged: @escaping () -> Void) {
      self.value = value
      self.onValueChanged = onValueChanged
    }
    
    @objc func sliderTouchUpInside(_ sender: UISlider) {
        self.value.wrappedValue = Double(sender.value)
        self.onValueChanged()
    }
  }
  
  func makeCoordinator() -> SongCenterSlider.Coordinator {
    Coordinator(value: $value, onValueChanged: onValueChanged)
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
      action: #selector(Coordinator.sliderTouchUpInside(_:)),
      for: .valueChanged
    )
    
    return slider
  }
  
  func updateUIView(_ uiView: UISlider, context: Context) {
    uiView.value = Float(value)
  }
}
