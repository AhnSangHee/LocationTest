//
//  locationTestApp.swift
//  locationTest
//
//  Created by Selina on 2023/04/04.
//

import SwiftUI

import ComposableArchitecture

@main
struct locationTestApp: App {
    
    let store: StoreOf<Gps> = Store(
        initialState: Gps.State(),
        reducer: Gps()
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
