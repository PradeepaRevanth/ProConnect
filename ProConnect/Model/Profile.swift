
//
//  Untitled.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

// MARK: - Domain Models


struct Profile: Identifiable, Equatable,Hashable {
    let id: UUID
    var name: String
    var profObjective: String
    var city: String
    var fieldOfWork: String
    var education: String
    var isAadharverified: Bool
    var age: Int
    var profileURL: URL?
}

enum SwipeDecision: Equatable {
    case like(Profile)
    case nope(Profile)
}
