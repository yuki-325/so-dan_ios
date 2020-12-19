//
//  AddConsultationViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/07.
//

import UIKit
import UITextView_Placeholder;

class AddConsultationViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        //print(UIColor(cgColor: contentsTextView.layer.borderColor!))
        //print(titleTextField.layer.borderWidth)
        contentsTextView.layer.borderWidth = 0.5
        contentsTextView.layer.borderColor = UIColor.rgba(red: 204, green: 204, blue: 204, alpha: 1).cgColor
        contentsTextView.layer.cornerRadius = 5
        contentsTextView.placeholder = "相談したいことを入力してください。"
        contentsTextView.placeholderColor = UIColor.rgba(red: 196, green: 196, blue: 196, alpha: 1)
        
        sendBtn.isEnabled = false
        sendBtn.layer.cornerRadius = sendBtn.layer.frame.height / 2
        
    }
    

   
}
