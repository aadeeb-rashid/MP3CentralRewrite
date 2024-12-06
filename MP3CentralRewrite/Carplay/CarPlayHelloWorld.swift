//
//  CarPlayHelloWorld.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/6/24.
//


import Foundation
import CarPlay

class CarPlayHelloWorld {
    var template: CPListTemplate {
        return CPListTemplate(title: "Hello world", sections: [self.section])
    }
    
    var items: [CPListItem] {
        return [CPListItem(text:"Hello world", detailText: "The world of CarPlay", image: UIImage(systemName: "globe"))]
    }
    
    private var section: CPListSection {
        return CPListSection(items: items)
    }
}