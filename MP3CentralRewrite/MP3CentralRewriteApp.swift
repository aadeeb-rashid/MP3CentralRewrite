//
//  MP3CentralRewriteApp.swift
//  MP3CentralRewrite
//
//  Created by Aadeeb Rashid on 12/5/23.
//

import SwiftUI
import SwiftData

@main
struct MP3CentralRewriteApp: App {
  @Environment(\.scenePhase) var scenePhase
  let persistenceController = LibraryCache.persistenceManager
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        LibraryView(viewModel: AppViewModel.shared)
          .environment(\.managedObjectContext, persistenceController.getContext())
          .onAppear {
            
          }
      }
    }
    .onChange(of: scenePhase) {
      persistenceController.save()
    }
  }
}
