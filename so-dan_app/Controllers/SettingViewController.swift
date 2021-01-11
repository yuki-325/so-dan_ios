//
//  SettingViewController.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/07.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let initialVC = storyboard?.instantiateViewController(identifier: Constants.initialVCStoryBordID) as! InitialViewController
            present(initialVC, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            AlertAction.alert(title: "ログアウト失敗", message: "ログアウトに失敗しました。お手数ですが、管理人にお問い合わせください。", viewController: self)
        }
    }
}

