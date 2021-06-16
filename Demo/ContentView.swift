//
//  ContentView.swift
//  Demo
//
//  Created by Евгений Суханов on 16.06.2021.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    private let _store: Store<AppState, AppEvent>

    init(store: Store<AppState, AppEvent>) {
        _store = store
    }

    var body: some View {
        WithViewStore(_store) { viewStore in
            Text(viewStore.title)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .init(
            initialState: .mock,
            reducer: appReducer,
            environment: .mock
        ))
    }
}
