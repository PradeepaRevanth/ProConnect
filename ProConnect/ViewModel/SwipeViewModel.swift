//
//  SwipeViewModel.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

@Observable final class SwipeViewModel {
    // Inputs / Config
    private let repo: ProfileProtocol
    private let dailySwipeCap: Int

    // State
    var deck: [Profile] = []        // top of deck is last element
    var isLoading = false
    var error: String? = nil
    var swipesToday = 0
    var lastDecision: SwipeDecision? = nil // for undo

    init(repo: ProfileProtocol, dailySwipeCap: Int = 30) {
        self.repo = repo
        self.dailySwipeCap = dailySwipeCap
    }

    @MainActor
    func loadIfNeeded() async {
        guard deck.isEmpty, !isLoading else { return }
        await refresh()
    }

    @MainActor
    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let batch = try await repo.fetchProfessionalData(limit: 10)
            deck = batch
        } catch {
            self.error = error.localizedDescription
        }
    }

    var canSwipe: Bool { swipesToday < dailySwipeCap }

    @MainActor
    func swipe(_ decision: SwipeDecision) {
        guard canSwipe, let top = deck.last else { return }
        // Ensure we are swiping the current top
        switch decision {
        case .like(let p), .nope(let p):
            guard p.id == top.id else { return }
        }
        _ = deck.popLast()
        swipesToday += 1
        lastDecision = decision
        // TODO: persist decision or trigger match if mutual like
    }

    @MainActor
    func undoLastSwipe() {
        guard let last = lastDecision else { return }
        switch last { case .like(let p), .nope(let p): deck.append(p) }
        lastDecision = nil
        swipesToday = max(0, swipesToday - 1)
    }
}
