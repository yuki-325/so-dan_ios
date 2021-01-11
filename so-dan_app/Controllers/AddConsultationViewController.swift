//
//  AddConsultationViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/07.
//

import UIKit
import Firebase
import UITextView_Placeholder;

class AddConsultationViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    let db = Firestore.firestore() //DBの参照
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(UIColor(cgColor: contentsTextView.layer.borderColor!))
        //print(titleTextField.layer.borderWidth)
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.borderColor = UIColor.rgba(red: 204, green: 204, blue: 204, alpha: 1).cgColor
        contentTextView.layer.cornerRadius = 5
        contentTextView.placeholder = "相談したいことを入力してください。"
        contentTextView.placeholderColor = UIColor.rgba(red: 196, green: 196, blue: 196, alpha: 1)
        sendBtn.isEnabled = false
        sendBtn.layer.cornerRadius = sendBtn.layer.frame.height / 2
        
        contentTextView.delegate = self
        titleTextField.delegate = self
        
        setUpNotificationForTextField()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        //入力内容をDBに保存
        if let title = titleTextField.text,
           let content = contentTextView.text,
           let senderEmail = Auth.auth().currentUser?.email {
            //ボタン連打防止
            titleTextField.text = ""
            contentTextView.text = ""
            
            let consultationData = [Constants.FStore.titleField: title,
                                    Constants.FStore.contentField: content,
                                    Constants.FStore.senderEmailField: senderEmail,
                                    Constants.FStore.receiverEmailField: Constants.adminEmail,
                                    Constants.FStore.createdAtField: Timestamp()] as [String : Any]
            
            db.collection(Constants.FStore.consultationsCollection)
                .addDocument(data: consultationData) { (error) in
                    if let _error = error {
                        print(_error.localizedDescription)
                        AlertAction.alert(title: "エラー", message: "データの保存に失敗しました。", viewController: self)
                        return
                    } else {
                        //チャット画面に移動
                        
                    }
                }
        }
    }
}

extension AddConsultationViewController: UITextFieldDelegate, UITextViewDelegate {
    //titleTextField, contentsTextViewの入力判定メソッド
    func textInputJubgment() {
        let titleIsEmpty = titleTextField.text?.isEmpty ?? true
        let contentsIsEmpty = contentTextView.text?.isEmpty ?? true
        
        if !titleIsEmpty && !contentsIsEmpty {
            sendBtn.isEnabled = true
            sendBtn.backgroundColor = UIColor.rgba(red: 66, green: 66, blue: 66, alpha: 1)
        } else {
            sendBtn.isEnabled = false
            sendBtn.backgroundColor = UIColor.rgba(red: 145, green: 145, blue: 145, alpha: 1)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textInputJubgment()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textInputJubgment()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードのenterを押下したらキーボードを閉じる(contentsTextViewは対象外)
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: - キーボード系処置
extension AddConsultationViewController {
    
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
        let sendBtnMaxY = sendBtn.frame.maxY
        let distance = sendBtnMaxY - keyboardMinY + 150
        let transform = CGAffineTransform(translationX: 0, y: distance)
        
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


