//
//  SwipeCardView.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

struct SwipeCardView: View {
    let profile: Profile
    let onSwipe: (SwipeDecision) -> Void
    let onOpenDetail: () -> Void

    @State private var offset: CGSize = .zero
    @State private var angle: Double = 0

    private let threshold: CGFloat = 120

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            GeometryReader { geo in
                AsyncImage(url: profile.profileURL) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(.gray.opacity(0.2))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Rectangle().fill(.gray.opacity(0.2))
                            .overlay(Image(systemName: "person.crop.circle.fill").font(.largeTitle))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
            }
            .frame(height: 520)

            LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .center, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("\(profile.name), \(profile.age)").font(.title2.bold()).foregroundStyle(.white)
                    if profile.isAadharverified { Label("Verified", systemImage: "checkmark.seal.fill").labelStyle(.titleAndIcon).foregroundStyle(.white) }
                }
                Text(profile.profObjective).font(.subheadline).foregroundStyle(.white.opacity(0.95))
                HStack(spacing: 8) {
                    Label {
                        Text(profile.city)
                    } icon: {
                        Image("location_icon")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 15, height: 15)
                            
                    }
                    Label(profile.fieldOfWork, systemImage: "briefcase")
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.9))
                Button("View details", action: onOpenDetail)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundStyle(.black)
                    .font(.subheadline.weight(.semibold))
                    .padding(.top, 8)
            }
            .padding(16)
        }
        .frame(height: 520)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(radius: 8)
        .offset(x: offset.width, y: 0)
        .rotationEffect(.degrees(angle))
        .gesture(
            DragGesture()
                .onChanged { value in
                    offset = value.translation
                    angle = Double(value.translation.width / 20)
                }
                .onEnded { value in
                    let dx = value.translation.width
                    if dx > threshold {
                        onSwipe(.like(profile))
                    } else if dx < -threshold {
                        onSwipe(.nope(profile))
                    } else {
                        withAnimation(.spring()) { offset = .zero; angle = 0 }
                    }
                }
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: offset)
        .padding(.horizontal, 24)
    }
}
