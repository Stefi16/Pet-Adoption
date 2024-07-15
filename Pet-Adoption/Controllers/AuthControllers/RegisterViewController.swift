//
//  RegisterViewController.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 19.06.24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var test: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .systemBackground;
    }
    
    @IBAction func onRegisterPressed(_ sender: UIButton) {
        loginPressed()
    }
    
    private func loginPressed() {
        guard let email = emailField.text, let pass = passwordField.text, let confirmPass = confirmPasswordField.text  else {
            return showAlert(message: "Please enter valid data in  all fields")
        }
        
        if pass != confirmPass {
            return showAlert(message: "Please enter matching passwords")
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { data, error in
            if let err = error {
                return self.showAlert(message: err.localizedDescription)
            }
            
            let user = AppUser.createNew(id: data!.user.uid, email: email)
            DataService.dataService.saveUser(user) { [weak self] sucess in
                if sucess {
                    self?.performSegue(withIdentifier: Constants.registerToMainSegue, sender: self)
                    
                    self?.emailField.text = ""
                    self?.passwordField.text = ""
                    self?.confirmPasswordField.text = ""
                } else {
                    self?.showAlert(message: "Something went wrong with saving the new user.", title: "Please try again.")
                }
            }
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            confirmPasswordField.resignFirstResponder()
            loginPressed()
        }
        
        return true
    }
}
