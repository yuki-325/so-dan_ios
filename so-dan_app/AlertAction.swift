//
//  AlertAction.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/03.
//

import UIKit

struct AlertAction {
    static func alert(title: String, message: String, viewController: UIViewController) {
        //var alertController: UIAlertController! //アラート用
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        viewController.present(alertController, animated: true)
    }
    
    static func alert(title: String, message: String, viewController: UIViewController, handler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let act1 = UIAlertAction(title: "OK", style: .default) { (action) in
            handler(true)
        }
        
        let act2 = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            handler(false)
        }
        
        alertController.addAction(act1)
        alertController.addAction(act2)
        
        viewController.present(alertController, animated: true)
    }
}
