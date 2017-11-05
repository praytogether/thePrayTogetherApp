//
//  RegisterViewController.swift
//  The Pray Together App
//
//  Created by Jason Mundie on 10/28/17.
//  Copyright © 2017 Jason Mundie. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    //    OUTLETS
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerButtonLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 75/2
        profileImage.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        registerButton.isEnabled = false
        
        handleTextField()
        
        hideKeyboardWhenTappedAround()
    }
    
    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        fullNameTextField.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    @objc func textFieldDidChange() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let fullName = fullNameTextField.text, !fullName.isEmpty else {
            registerButtonLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            registerButton.isEnabled = false
            return
        }
        registerButtonLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        registerButton.isEnabled = true 
    }
    
    @objc func handleSelectProfileImageView() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("camera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, andUsername: self.usernameTextField.text!, andBio: "", andFullName: fullNameTextField.text!, andProfileImage: "", userCreationComplete: { (success, registrationError) in
            if success {
                AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passwordTextField.text!, loginComplete: { (success, nil) in
                    self.performSegue(withIdentifier: "registerToTabBarId", sender: self)
                })
            } else {
                print(String(describing: registrationError?.localizedDescription))
            }
        })
        
        
        
        guard let image = self.profileImage.image else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Storage.storage().reference().child("Profile Images").child("users").child(uid).putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Failed to upload profile picture", error)
                return
            }
            
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("successfully uploaded profile picture", profileImageUrl)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Database.database().reference().child("users").child(uid).updateChildValues(["profileImage" : profileImageUrl])
        
        
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = originalImage
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = #colorLiteral(red: 0.5352031589, green: 0.6165366173, blue: 0.6980209947, alpha: 1)
        profileImage.layer.borderWidth = 3
        
        picker.dismiss(animated: true, completion: nil)
        
        
        
        
        
        
}
}
