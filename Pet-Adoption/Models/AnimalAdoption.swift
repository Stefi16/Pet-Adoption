import Foundation

struct AnimalAdoption: Codable {
    let adoptionId: String
    let userId: String
    let animalName: String
    let genderType: AnimalGender
    let animalType: AnimalType
    let isApproved: Bool
    let breed: String?
    let country: String
    let city: String
    let description: String
    let photoUrl: String?
    let animalAge: AnimalAge
    let datePublished: String?
    
    
    var getFormattedCountry: String {
        return "\(city), \(country)"
    }
}
