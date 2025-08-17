//
//  Untitled.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//

import SwiftUI
import Combine

struct AppRootView: View {
    @State private var router = Router()
    @State private var vm = SwipeViewModel(repo: MockProfile())

    var body: some View {
        NavigationStack(path: $router.path) {
            SwipeMainView(vm: vm, router: router)
                .navigationDestination(for: Router.Route.self) { route in
                    switch route {
                    case .detail(let p): ProfileDetailView(profile: p)
                    }
                }
        }
    }
}

// MARK: - Preview

#Preview {
    AppRootView()
}
