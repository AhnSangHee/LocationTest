//
//  ContentView.swift
//  locationTest
//
//  Created by Selina on 2023/04/04.
//

import SwiftUI

import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<Gps>
    
    public init(store: StoreOf<Gps>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            VStack {
                Text("GpsView")
                    .onAppear {
                        //                        viewStore.send(.onAppear)
                        viewStore.send(.requestAuthorization)
                    }
                    .alert(self.store.scope(state: \.alert), dismiss: .alertDismissed)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: Gps.State(),
                reducer: Gps()
            )
        )
    }
}
