//
//  ViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/11/18.
//

import UIKit

import MaterialComponents.MaterialTextControls_OutlinedTextFields

class SigninViewController: UIViewController{


    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var usernameTextField: MDCOutlinedTextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        emailTextField.label.text = "e-mail"
        passwordTextField.label.text = "password"
        usernameTextField.label.text = "ユーザ名"
        signupBtn.layer.cornerRadius = signupBtn.frame.height / 2
        
        
        

    }
    

   

}
