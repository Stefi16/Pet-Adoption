//
//  AnimalAge.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 20.06.24.
//

import Foundation

struct AnimalAge: Codable {
    let years: Int
    let months: Int
    
    
    var getFormattedAge: String {
        if years == 0 {
            return "\(months)m."
        }
            
        if months == 0 {
            return "\(years)y."
        }
            
        return "\(years)y. \(months)m."
    }
}
