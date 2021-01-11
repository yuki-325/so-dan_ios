//
//  UserModel.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/02.
//

import Foundation
import Firebase

struct User {
    var email: String
    var username: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.email = dic[Constants.FStore.emailField] as! String
        self.username = dic[Constants.FStore.usernameField] as! String
        self.createdAt = dic[Constants.FStore.createdAtField] as! Timestamp
    }
}
