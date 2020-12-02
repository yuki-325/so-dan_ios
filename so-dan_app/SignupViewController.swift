//
//  ViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/11/18.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields
import Firebase

class SignupViewController: UIViewController{
    
    var alertController: UIAlertController! //アラート用
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var usernameTextField: MDCOutlinedTextField!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        emailTextField.label.text = "e-mail"
        passwordTextField.label.text = "password"
        usernameTextField.label.text = "ユーザ名"
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        usernameTextField.clearButtonMode = .whileEditing

        signupBtn.layer.cornerRadius = signupBtn.frame.height / 2
        signupBtn.isEnabled = false
        
        setUpNotificationForTextField()
    }
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        signupAction()
    }
}


//MARK: - UITextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        
        if !emailIsEmpty && !passwordIsEmpty && !usernameIsEmpty {
            signupBtn.isEnabled = true
            signupBtn.backgroundColor = UIColor.rgba(red: 66, green: 66, blue: 66, alpha: 1)
        } else {
            signupBtn.isEnabled = false
            signupBtn.backgroundColor = UIColor.rgba(red: 145, green: 145, blue: 145, alpha: 1)
        }
    }
    
    //キーボードのEnterを押下するとキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - キーボード系の処理
extension SignupViewController {
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
        let registerBtnMaxY = signupBtn.frame.maxY
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

//MARK: - sign up
extension SignupViewController {
    //サインアップ＆FireStoreにデータを保存
    private func signupAction() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let _error = error {
                //TODO:アラート作成 すでに使用されているemailがあるかパスワードが6文字以上でない可能性があります
                switch _error.localizedDescription {
                case "The email address is already in use by another account.":
                    self.alert(title: "エラー", message: "入力したメールアドレスはすでに別のアカウントで使用されています")
                case "The email address is badly formatted.":
                    self.alert(title: "エラー", message: "入力したメールアドレスの形式が正しくありません。")
                case "The password must be 6 characters long or more.":
                    self.alert(title: "エラー", message: "パスワードは6文字以上である必要があります。")
                default:
                    self.alert(title: "エラー", message: "予期せぬエラー")
                }
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let docData = ["email": email, "username": username, "createdAt": Timestamp()] as [String: Any]
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            userRef.setData(docData) { (error) in
                if let _error = error {
                    print(_error.localizedDescription)
                    self.alert(title: "エラー", message: "データベースの保存に失敗しました。")
                    return
                }
                
                userRef.getDocument { (snapShoe, error) in
                    if let _error = error {
                        print(_error.localizedDescription)
                        self.alert(title: "エラー", message: "ユーザ情報の取得に失敗しました。")
                        return
                    }
                    
                    let userData = User.init(dic: (snapShoe?.data())!) //取得したユーザ情報をUser型へ
                    print(userData.email)
                    
                }
                self.alert(title: "登録完了", message: "アカウントの作成が完了しました。")
            }
        }
    }
}

//MARK: - アラート ベース
extension SignupViewController {
    func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
}


