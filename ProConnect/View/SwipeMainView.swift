//
//  SwipeView.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

struct SwipeMainView: View {
    @Bindable var vm: SwipeViewModel
    @Bindable var router: Router

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [.black.opacity(0.02), .clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                deckView
                controls
            }
            .padding()
        }
        .task { await vm.loadIfNeeded() }
        .overlay(alignment: .bottomTrailing) {
            if !vm.canSwipe {
                Text("Daily swipe limit reached")
                    .padding(8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding()
            }
        }
    }

    // MARK: Subviews

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Discover")
                    .font(.largeTitle.bold())
                Text("Swipe to connect with professionals")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: { Task { await vm.refresh() } }) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
        }
    }

    private var deckView: some View {
        ZStack {
            ForEach(vm.deck) { profile in
                SwipeCardView(profile: profile) { decision in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        vm.swipe(decision)
                    }
                } onOpenDetail: {
                    router.goToDetail(profile)
                }
                .stacked(at: index(of: profile), in: vm.deck.count)
            }
            if vm.isLoading { ProgressView().scaleEffect(1.2) }
            if vm.deck.isEmpty && !vm.isLoading {
                ContentUnavailableView("No more profiles", systemImage: "person.2.slash", description: Text("Pull to refresh for a new batch"))
            }
        }
        .frame(maxHeight: .infinity)
    }

    private func index(of profile: Profile) -> Int { vm.deck.firstIndex(of: profile) ?? 0 }

    private var controls: some View {
        HStack(spacing: 24) {
            Button(action: { vm.undoLastSwipe() }) {
                Image(systemName: "arrow.uturn.left")
                    .font(.title2)
            }
            .disabled(vm.lastDecision == nil)
            .buttonStyle(BtnRefresh())

            Spacer()

            Button(action: {
                guard vm.canSwipe, let top = vm.deck.last else { return }
                withAnimation(.easeInOut) { vm.swipe(.nope(top)) }
            }) {
                Image(systemName: "xmark")
                    .font(.title)
            }
            .buttonStyle(BtnCancel())

            Button(action: {
                guard vm.canSwipe, let top = vm.deck.last else { return }
                withAnimation(.easeInOut) { vm.swipe(.like(top)) }
            }) {
                Image(systemName: "checkmark")
                    .font(.title)
            }
            .buttonStyle(BtnPrimary())
        }
        .padding(.horizontal)
    }
}

// MARK: - Styles

struct BtnPrimary: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(22)
            .background(Circle().fill(.blue.opacity(configuration.isPressed ? 0.7 : 1)))
            .foregroundStyle(.white)
            .shadow(radius: configuration.isPressed ? 0 : 6)
    }
}

struct BtnCancel: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(22)
            .background(Circle().fill(.red.opacity(configuration.isPressed ? 0.7 : 1)))
            .foregroundStyle(.white)
            .shadow(radius: configuration.isPressed ? 0 : 6)
    }
}

struct BtnRefresh: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(18)
            .background(Circle().strokeBorder(.secondary, lineWidth: 1))
            .foregroundStyle(.secondary)
    }
}


// MARK: - Utilities: View Modifiers

extension View {
    func stacked(at index: Int, in total: Int) -> some View {
        let offset = Double(total - 1 - index) * 6.0
        return self.offset(y: CGFloat(offset)).scaleEffect(1 - CGFloat(offset)/300)
    }
}
