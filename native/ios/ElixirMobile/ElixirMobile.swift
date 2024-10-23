//
//  ElixirMobile.swift
//  ElixirMobile
//

import SwiftUI

@main
struct ElixirMobile: App {
    @Environment(\.scenePhase) var scenePhase
    
    var content = ContentView()
    var body: some Scene {
        WindowGroup {
            self.content
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                print(".background")
            case .active:
                print(".active")
                if let bridge = Bridge.instance {
                    bridge.reinit()
                }
            default: break
            }
        }

    }
}
