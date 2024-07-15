//
//  LoginViewController.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 19.06.24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func onLoginTap(_ sender: UIButton) {
        loginPressed()
    }
    
    private func loginPressed() {
        guard let email = emailField.text, let pass = passwordField.text else {
            return showAlert(message: "Email or Password is not entered.")
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { data, error in
            
            if let err = error {
                self.showAlert(message: err.localizedDescription)
            } else {
                self.performSegue(withIdentifier: Constants.loginToMainSegue, sender: self)
                
                self.emailField.text = ""
                self.passwordField.text = ""
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            passwordField.resignFirstResponder()
            loginPressed()
        }
        
        return true
    }
}
