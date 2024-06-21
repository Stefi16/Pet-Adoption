//
//  Constants.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 19.06.24.
//

import Foundation

struct Constants {
    
    // MARK: Segue constants
    static let loginSegue: String = "loginScreen"
    static let registerToMainSegue: String = "fromRegisterToMain"
    static let loginToMainSegue: String = "fromLoginToMain"
    static let userLoggedInSegue: String = "userLoggedIn"
    static let petProfileSegue: String = "petProfile"
    
    
    //MARK: Firebase collections names
    static let adoptionsCollectionName = "animal_adoption"
    
    
    //MARK: Cell identifiers
    static let adoptionsCell = "adoptionCell"
    static let adoptionCellName = "AdoptionsCollectionViewCell"
}
