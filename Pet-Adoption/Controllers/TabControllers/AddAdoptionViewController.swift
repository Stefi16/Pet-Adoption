//
//  AddAdoptionViewController.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 25.06.24.
//

import UIKit
import FirebaseAuth

class AddAdoptionViewController: ImagePickerViewController  {
    @IBOutlet weak var addAdoptionButton: UIButton!
    @IBOutlet weak var adoptionImage: UIImageView!
    @IBOutlet weak var genderTypeButton: UISegmentedControl!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var breedField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var chooseTypeButton: UIButton!
    @IBOutlet weak var chooseAgeButton: UIButton!
    
    private var chosenAnimalType: AnimalType?
    var selectedMonths: String?
    var selectedYear: String?
    var isButtonClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        adoptionImage.addGestureRecognizer(tapGestureRecognizer)
        
        addRoundedCorners(to: adoptionImage, corners: [.bottomLeft, .topLeft, .bottomRight, .topRight])
        addRoundedCorners(to: addAdoptionButton, corners: [.bottomLeft, .topLeft, .bottomRight, .topRight])
        
        chooseAgeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        setDelegates()
    }
    
    private func setDelegates() {
        super.delegate = self
        picker.delegate = self
        nameField.delegate = self
        breedField.delegate = self
        countryField.delegate = self
        cityField.delegate = self
        descriptionField.delegate = self
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        showActionSheet()
    }
    
    @IBAction func chooseAnimalType(_ sender: UIButton) {
        clearSelectedType()
        
        let alert = UIAlertController(title: "Select Animal Type", message: nil, preferredStyle: .actionSheet)
        
        for type in AnimalType.allCases {
            let action = UIAlertAction(title: type.rawValue.capitalized, style: .default) { [weak self] _ in
                self?.chosenAnimalType = type
                self?.chooseTypeButton.setTitle("Choose: \(type.rawValue.capitalizeFirstLetter())", for: .normal)
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func chooseAnimalAge(_ sender: UIButton) {
        clearSelectedAge()
        
        let alertController = UIAlertController(title: "Select Month and Year", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let screenWidth = self.view.frame.size.width
        let pickerView = UIPickerView(frame:
                                        CGRect(x: 0, y: 50, width: screenWidth, height: 162))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        alertController.view.addSubview(pickerView)
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { _ in
            self.selectedMonths = self.selectedMonths ?? "1m."
            self.selectedYear = self.selectedYear ?? "0y."
            
            self.chooseAgeButton.setTitle("Choose: \(self.selectedYear!) \(self.selectedMonths!)", for: .normal)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func areAllFieldsValid() -> Bool {
        return nameField.isFieldValid && countryField.isFieldValid && cityField.isFieldValid && descriptionField.isFieldValid
    }
    
    private func isAgeValid() -> Bool {
        if let _ = selectedMonths?.first?.wholeNumberValue, let _ = selectedYear?.first?.wholeNumberValue {
            return true
        }
        
        return false
    }
    
    @IBAction func addAdoptionTap(_ sender: UIButton) {
        onAddAdoptionTap()
    }
    
    func onAddAdoptionTap() {
        if areAllFieldsValid() && chosenAnimalType != nil && isAgeValid() {
            guard let monthsInt = selectedMonths?.first?.wholeNumberValue, let yearsInt = selectedYear?.first?.wholeNumberValue, let animalType = chosenAnimalType else {
                return
            }
            
            if isButtonClicked {
                return
            }
            
            isButtonClicked = true
            
            let age = AnimalAge(years: yearsInt, months: monthsInt)
            let userId = Auth.auth().currentUser?.uid ?? ""
            let gender: AnimalGender = genderTypeButton.selectedSegmentIndex == 0 ? .male : .female
            let uuid = UUID().uuidString
            
            UploadImageService.reference.uploadImage(image: adoptionImage.image?.jpegData(compressionQuality: 0.8), adoptionId: uuid) { [weak self] url in
                let newAdoption = AnimalAdoption(adoptionId: uuid, userId: userId, animalName: self!.nameField.text!, genderType: gender, animalType: animalType, isApproved: false, breed: self!.breedField.text, country: self!.countryField.text!, city: self!.cityField.text!, description: self!.descriptionField.text!, photoUrl: url, animalAge: age, datePublished: Date().formattedString)
                
                DataService.dataService.saveAdoption(newAdoption) { sucesss in
                    if sucesss {
                        self?.clearScreenData()
                    }
                    
                    self?.isButtonClicked = false
                }
            }
            return
        }
        
        showAlert(message: "Please enter description field with at least ten characters, all mandatory fields with at least two characters, age and type.", title: "All fields are not valid!")
    }
    
    private func clearScreenData() {
        nameField.text = ""
        adoptionImage.image = UIImage(named: "placeholder")
        genderTypeButton.selectedSegmentIndex = 0
        
        clearSelectedType()
        clearSelectedAge()
        
        breedField.text = ""
        countryField.text = ""
        cityField.text = ""
        descriptionField.text = ""
    }
    
    private func clearSelectedAge() {
        selectedYear = nil
        selectedMonths = nil
        chooseAgeButton.setTitle("Choose: Age", for: .normal)
    }
    
    private func clearSelectedType() {
        chosenAnimalType = nil
        chooseTypeButton.setTitle("Choose: Type", for: .normal)
    }
}

//MARK: ImagePickerProtocol
extension AddAdoptionViewController: ImagePickerProtocol {
    func passImageData(_ image: UIImage?) {
        adoptionImage.image = image
    }
}

//MARK: PickerView
extension AddAdoptionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    var months: [String] {
        return (1...12).map { "\($0)m." }
    }
    var years: [String] {
        return (0...25).map { "\($0)y." }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 //one for months and one for years
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? years.count : months.count
    }
    
    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? years[row] : months[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedYear = years[row]
        } else {
            selectedMonths = months[row]
        }
    }
    
    func validateTextField(_ textField: UITextField) {
        if textField == self.breedField {
            return
        }
        
        if let safeText = textField.text {
            let characterValidationLength = textField == descriptionField ? 10 : 2
            let isValid = ValidatorService.validateStringLength(safeText,  characterValidationLength)
            
            textField.layer.borderColor = isValid ? UIColor.clear.cgColor : UIColor.red.cgColor
            textField.layer.borderWidth = 2.0
            textField.layer.cornerRadius = 5
        }
    }
}

//MARK: UITextFieldDelegate
extension AddAdoptionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            nameField.resignFirstResponder()
        } else if textField == breedField {
            countryField.becomeFirstResponder()
        } else if textField == countryField {
            cityField.becomeFirstResponder()
        } else if textField == cityField {
            descriptionField.becomeFirstResponder()
        } else if textField == descriptionField {
            descriptionField.resignFirstResponder()
            onAddAdoptionTap()
        }
        
        return true
    }
}
