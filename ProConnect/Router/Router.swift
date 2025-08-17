//
//  Router.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

@Observable final class Router {
    enum Route: Hashable {
        case detail(Profile)
    }
    var path: [Route] = []
    func goToDetail(_ p: Profile) { path.append(.detail(p)) }
}

