//
//  ProConnectApp.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//

import SwiftUI

@main
struct ProConnectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
