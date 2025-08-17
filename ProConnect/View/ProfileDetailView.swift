//
//  ProfileDetailView.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

struct ProfileDetailView: View {
    let profile: Profile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: profile.profileURL) { phase in
                    switch phase {
                    case .empty: ProgressView()
                    case .success(let img): img.resizable().scaledToFill()
                    case .failure: Color.gray.opacity(0.2)
                    @unknown default: EmptyView()
                    }
                }
                .frame(height: 280)
                .clipped()
                .overlay(
                    LinearGradient(colors: [.clear, .black.opacity(0.65)], startPoint: .center, endPoint: .bottom)
                , alignment: .bottom)
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        Text("\(profile.name), \(profile.age)").font(.title.bold()).foregroundStyle(.white)
                        Text(profile.profObjective).foregroundStyle(.white.opacity(0.95))
                    }
                    .padding()
                }

                VStack(alignment: .leading, spacing: 12) {
                    Label(profile.city, systemImage: "mappin.and.ellipse")
                    Label(profile.fieldOfWork, systemImage: "briefcase")
                    Label(profile.education, systemImage: "graduationcap")
                    if profile.isAadharverified { Label("Verified profile", systemImage: "checkmark.seal.fill") }
                }
                .font(.body)
                .padding(.horizontal)
                Text("About")
                    .font(.headline)
                    .padding(.horizontal)
                Text("Experienced professional passionate about \(profile.fieldOfWork). Open to connecting with peers in \(profile.city).")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Spacer(minLength: 40)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
