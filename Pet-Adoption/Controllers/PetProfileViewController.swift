//
//  PetProfileViewController.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 20.06.24.
//

import UIKit

class PetProfileViewController: UIViewController {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var animalName: UILabel!
    
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var petTypeBackground: UIImageView!
    @IBOutlet weak var agePetBackground: UIImageView!
    
    @IBOutlet weak var genderTypeIcon: UIImageView!
    @IBOutlet weak var animalTypeIcon: UIImageView!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    var adoption: AnimalAdoption?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
        inputAdoptionData()
        addBRoundedCorners(to: infoView, corners
                           : [.topLeft, .topRight])
        addBRoundedCorners(to: genderImage, corners
                           : [.topLeft, .topRight, .bottomLeft, .bottomRight])
        addBRoundedCorners(to: petTypeBackground, corners
                           : [.topLeft, .topRight, .bottomLeft, .bottomRight])
        addBRoundedCorners(to: agePetBackground, corners
                           : [.topLeft, .topRight, .topLeft, .topRight, .bottomLeft, .bottomRight])
        
        
        self.navigationController?.navigationBar.tintColor = .systemIndigo;
        
    }
    
    private func addBRoundedCorners(to view: UIView, corners: UIRectCorner) {
        view.layer.cornerRadius = 20.0
        view.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
    
    private func inputAdoptionData() {
        guard let adoption = self.adoption  else {
            return
        }
        
        
        if let url = URL(string: adoption.photoUrl ?? "") {
            petImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        animalName.text = adoption.animalName
        locationLabel.text = adoption.getFormattedCountry
        
        switch adoption.genderType {
            case .female:
                genderImage.image = UIImage(named: "female-pet-background")
            case .male:
                genderImage.image = UIImage(named: "male-pet-background")
        }
        
        animalTypeIcon.image = UIImage(systemName: adoption.animalType.getProperTypeIcon)
        genderTypeIcon.image = UIImage(systemName: adoption.genderType.getProperGenderIcon)
        ageLabel.text = adoption.animalAge.getFormattedAge
        
    }
    @IBAction func descriptionPressed(_ sender: UIButton) {
        if let description = adoption?.description {
            showAlert(message: description, title: "Pet Descritpion")
        }
    }
}
