//
//  ProfileDetailView.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

import SwiftUI

struct ProfileDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let profile: Profile
    
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ScrollView {
                    ZStack {
                        // MARK: - Image with parallax
                        GeometryReader { imgGeo in
                            let minY = imgGeo.frame(in: .global).minY
                            AsyncImage(url: profile.profileURL) { phase in
                                switch phase {
                                case .empty: ProgressView()
                                case .success(let img): img.resizable().aspectRatio(contentMode: .fill)
                                case .failure: Color.gray.opacity(0.2)
                                @unknown default: EmptyView()
                                }
                            }
                            .frame(width: geo.size.width,
                                   height: max(geo.size.height / 2 + (minY > 0 ? minY : 0), 300))
                            .clipped()
                            .overlay(
                                LinearGradient(colors: [.clear, Color.black.opacity(0.55)],
                                               startPoint: .center,
                                               endPoint: .bottom),
                                alignment: .bottom
                            )
                            .offset(y: (minY > 0 ? -minY : 0))
                        }
                        .frame(height: geo.size.height / 2)
                    }
                    
                    // MARK: - Profile Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(profile.name), \(profile.age)")
                            .font(.title.bold())
                            .foregroundStyle(.primary)
                        
                        Text(profile.profObjective)
                            .foregroundStyle(.secondary)
                        
                        Divider()
                        
                        Label {
                            Text(profile.city)
                        } icon: {
                            Image("location_icon")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 20)
                                
                        }
                        Label(profile.fieldOfWork, systemImage: "briefcase")
                        Label(profile.education, systemImage: "graduationcap")
                        if profile.isAadharverified {
                            Label("Verified profile", systemImage: "checkmark.seal.fill")
                        }
                        
                        Divider()
                        
                        Text("About")
                            .font(.headline)
                        Text("Experienced professional passionate about \(profile.fieldOfWork). Open to connecting with peers in \(profile.city).")
                            .foregroundStyle(.secondary)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color(uiColor: .systemBackground))
//                            .shadow(color: .black.opacity(0.2), radius: 5)
                    )
                    .offset(y: -40) // pull up over the image
                    .animation(.spring(), value: scrollOffset)
                    .zIndex(1)
                }
                
                // MARK: - Custom Back Button
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(.top, 50)
                .padding(.leading)
                .zIndex(2)
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)
        }
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = 24
    var corners: UIRectCorner = [.allCorners]
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
