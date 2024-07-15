//
//  ValidatorService.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 28.06.24.
//

import Foundation

struct ValidatorService {
    static func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: email)
    }
    
    static func validateStringLength(_ string: String, _ length: Int) -> Bool {
        return string.count > length
    }
}
