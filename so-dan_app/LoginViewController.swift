//
//  LoginViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/11/18.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Firebase

class LoginViewController: UIViewController {
    
    var activeTextField: UITextField?
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.label.text = "email"
        passwordTextField.label.text = "password"
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        loginBtn.isEnabled = false
        setUpNotificationForTextField()
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        //textField下の文字初期化
        emailTextField.trailingAssistiveLabel.text = ""
        passwordTextField.trailingAssistiveLabel.text = ""
        
        //ボタンを押下した時にactiveなテキストフィールドからフォーカスを外す
        if let _activeTextField = activeTextField {
            _activeTextField.resignFirstResponder()
        }
        
        loginAction()
    }
    
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if !emailIsEmpty && !passwordIsEmpty {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = UIColor.rgba(red: 66, green: 66, blue: 66, alpha: 1)
        } else {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = UIColor.rgba(red: 145, green: 145, blue: 145, alpha: 1)
        }
    }
    
    //キーボードのEnterを押下するとキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //activeなテキストフィールドを取得する
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
}


//MARK: - キーボード系処置
extension LoginViewController {
    func setUpNotificationForTextField() {
        let notificationCenter = NotificationCenter.default
        //キーボードが出る時に呼ばれる
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_ :)),
                                       name:UIResponder.keyboardWillShowNotification, object: nil)
        //キーボードが隠れる時に呼ばれる
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_ :)),
                                       name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //キーボードが出てきた時の処理
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        guard let keyboardMinY = keyboardFrame?.minY else { return }
        let registerBtnMaxY = loginBtn.frame.maxY
        let distance = registerBtnMaxY - keyboardMinY + 60
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
    }
    
    //キーボードが隠れた時の処理
    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    //キーボード・テキストフィールド以外のところをタッチするとキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


//MARK: - ログインの処理
extension LoginViewController {
    func loginAction() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let _error = error {
                let errorTextColor = UIColor.rgba(red: 255, green: 0, blue: 0, alpha: 0.7) //テキストフィールド下に表示する文字のカラー
                let errorCode = AuthErrorCode(rawValue: _error._code)
                switch errorCode {
                case .invalidEmail:
                    self.emailTextField.trailingAssistiveLabel.text = "※入力したメールアドレスの形式が正しくありません。"
                    self.emailTextField.setTrailingAssistiveLabelColor(errorTextColor, for: .normal)
                    //self.alert(title: "エラー", message: "入力したメールアドレスの形式が正しくありません。")
                case .wrongPassword:
                    self.passwordTextField.trailingAssistiveLabel.text = "※パスワードが間違っています。"
                    self.passwordTextField.setTrailingAssistiveLabelColor(errorTextColor, for: .normal)
                    
                case .userNotFound:
                    self.emailTextField.trailingAssistiveLabel.text = "※入力したメールアドレスのユーザは存在しません。"
                    self.emailTextField.setTrailingAssistiveLabelColor(errorTextColor, for: .normal)
                default:
                    AlertAction.alert(title: "エラー", message: "予期せぬエラー", viewController: self)
                    print(_error.localizedDescription as String)
                }
                return
            }
        
            let user = Auth.auth().currentUser
            
            print(user?.email)
            //print(result?.user.email)
        }
    }
}
