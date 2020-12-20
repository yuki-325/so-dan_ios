//
//  Contents.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/20.
//

import Foundation
import Firebase

struct Consultation {
    var title: String
    var contents: String
    var senderEmail: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.title = dic["title"] as! String
        self.contents = dic["contents"] as! String
        self.senderEmail = dic["senderEmail"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
    }
}
