//
//  Enums.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 20.06.24.
//

import Foundation

enum AnimalGender: String, Codable {
    case female
    case male
    
    var getProperGenderIcon: String {
        switch self {
        case .female:
            return "mouth.fill"
        case .male:
            return "mustache.fill"
        }
    }
}

enum AnimalType: String, Codable, CaseIterable {
    case cat
    case dog
    case bird
    case rabbit
    case fish
    case other
    
    var getProperTypeIcon: String {
        switch self {
        case .cat:
            return "cat.fill"
        case .dog:
            return "dog.fill"
        case .bird:
            return "bird.fill"
        case .rabbit:
            return "hare.fill"
        case .fish:
            return "fish.fill"
        default:
            return "tortoise.fill"
        }
    }
}
