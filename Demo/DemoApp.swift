//
//  DemoApp.swift
//  Demo
//
//  Created by Евгений Суханов on 16.06.2021.
//

import SwiftUI

@main
struct DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
