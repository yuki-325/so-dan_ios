//
//  AlertAction.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/03.
//

import UIKit

struct AlertAction {
    static func alert(title:String, message:String, viewController: UIViewController) {
        var alertController: UIAlertController! //アラート用
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        viewController.present(alertController, animated: true)
    }
}
