//
//  User.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 24.06.24.
//

import Foundation

struct AppUser: Codable {
    var id: String
    var email: String
    var username: String?
    var favouritePosts: [String]
    var dateJoined: Date
    var picture: String?
    var phone: String?
    var isAdmin: Bool
    var isDarkMode: Bool
    
    static func createNew(id: String, email: String) -> AppUser {
        return AppUser(
            id: id,
            email: email,
            favouritePosts: [],
            dateJoined: Date(),
            isAdmin: false,
            isDarkMode: false
        )
    }
}
