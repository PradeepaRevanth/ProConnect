//
//  MockProfile.swift
//  ProConnect
//
//  Created by Pradeepa on 17/08/25.
//
import SwiftUI
import Combine

protocol ProfileProtocol {
    func fetchProfessionalData(limit: Int) async throws -> [Profile]
}

final class MockProfile: ProfileProtocol {
    func fetchProfessionalData(limit: Int) async throws -> [Profile] {
        try await Task.sleep(nanoseconds: 200_000_000)
        let photos = [
//            "","","","","","","","","",""
            "https://t4.ftcdn.net/jpg/04/43/25/95/360_F_443259545_PsPbDmm8HY7JLQU9Ew9DPOdAHtIhMtnD.jpg",
            "https://i.pinimg.com/736x/77/71/68/7771683223d86b237a3304d6f32828b9.jpg",
            "https://t4.ftcdn.net/jpg/03/25/73/59/360_F_325735908_TkxHU7okor9CTWHBhkGfdRumONWfIDEb.jpg",
            "https://images.unsplash.com/photo-1502685104226-ee32379fefbe",
            "https://images.unsplash.com/photo-1531123897727-8f129e1688ce",
            "https://heroshotphotography.com/wp-content/uploads/2023/03/male-linkedin-corporate-headshot-on-white-square-1024x1024.jpg",
            "https://cdn.myportfolio.com/34b839f6562dc845f8265e2435b68d97/93650d9a-6c6b-4851-a0fb-8710b068b769_rw_600.jpg?h=e557d75cc2421438b921845048e9e58c",
            "https://images.squarespace-cdn.com/content/v1/574512d92eeb81676262d877/1dc1f125-b7d6-4302-8d3b-b25c3dc2a546/Headshot-Photographer-London-UK-Ian-Kobylanki-292.jpg",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpjod6nHkIO9UnaSdWUdPAUtTj5KVDESGc0Q&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQY9b_u54JNRxi87Sk4eVhIzrB3B8AJAWMNqw&s"
        ]
        func mockData(_ i: Int) -> Profile {
            Profile(
                id: UUID(),
                name: ["Pradeepa", "Diya", "Kabir", "Ishita", "Monika","John","Alana","Jersy","Swersy","Micheal"].randomElement()!,
                profObjective: ["iOS Engineer", "Data Scientist", "Product Manager", "Flutter Developer", "Backend Engineer","Mobile Developer","Android Engineer","FullStack Engineer","iOS Lead","Senior iOS Engineer"].randomElement()!,
                city: ["Bengaluru", "Chennai", "Hyderabad", "Pune", "Delhi","Chennai","Coimbatore","Dubai","Abudhabi","Bangalore"].randomElement()!,
                fieldOfWork: ["Mobile", "AI/ML", "Product", "Full‑Stack", "Cloud","Mobility","Android","Full-Stack","iOS-Mobile","iOS-Mobile"].randomElement()!,
                education: ["B.E.", "B.Tech", "MCA", "M.Tech","B.E.","M.Tech","MS","M.E","B.Tech","BSc"].randomElement()!,
                isAadharverified: Bool.random(),
                age: Int.random(in: 21...35),
                profileURL: URL(string: photos.randomElement()!)
            )
        }
        return (0..<limit).map(mockData)
    }
}


