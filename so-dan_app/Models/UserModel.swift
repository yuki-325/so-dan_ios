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
        self.email = dic["email"] as! String
        self.username = dic["username"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
    }
}
