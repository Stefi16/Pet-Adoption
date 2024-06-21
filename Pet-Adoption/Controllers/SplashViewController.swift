//
//  ViewController.swift
//  Pet-Adoption
//
//  Created by Stefka Krachunova on 18.06.24.
//

import UIKit
import Lottie
import FirebaseAuth

class SplashViewController: UIViewController {
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        animationView.play()
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { timer in
            let user = Auth.auth().currentUser
            
            if user != nil {
                return self.performSegue(withIdentifier: Constants.userLoggedInSegue, sender: self)
            }
            
            self.performSegue(withIdentifier: Constants.loginSegue, sender: self)
        }
    }
    
}

