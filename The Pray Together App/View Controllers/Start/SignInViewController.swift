//
//  SignInViewController.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 10/28/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
//    OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleTextField()
       
        hideKeyboardWhenTappedAround()
        signInButtonLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        signInButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "SignInToTabBarId", sender: nil)
        }
        
    }

    func handleTextField() {
        
        emailTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButtonLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            signInButton.isEnabled = false
            return
        }
        signInButtonLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        signInButton.isEnabled = true
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!, loginComplete: { (success, loginError) in
            if success {
               
                self.signInButtonLabel.text = "SUCCESS"
                self.performSegue(withIdentifier: "SignInToTabBarId", sender: self)
            } else {
                
                self.signInButtonLabel.text = "ERROR, TRY AGAIN"
                print(String(describing: loginError?.localizedDescription))
                
            }
    
        }
    )}
}
