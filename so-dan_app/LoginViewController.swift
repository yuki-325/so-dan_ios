//
//  LoginViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/11/18.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.label.text = "email"
        passwordTextField.label.text = "password"
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2

    }
    

    
}
