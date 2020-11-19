//
//  ViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/11/18.
//

import UIKit

class InitialViewController: UIViewController {
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.borderWidth = 1
        signupBtn.layer.borderColor = UIColor.rgb(red: 53, green: 53, blue: 53).cgColor
        signupBtn.layer.cornerRadius = signupBtn.frame.height / 2
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        
        
    }


}

