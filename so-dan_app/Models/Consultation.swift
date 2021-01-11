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
    var content: String
    var senderEmail: String
    var receiverEmail: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.title = dic[Constants.FStore.titleField] as! String
        self.content = dic[Constants.FStore.contentField] as! String
        self.senderEmail = dic[Constants.FStore.senderEmailField] as! String
        self.receiverEmail = dic[Constants.FStore.receiverEmailField] as! String
        self.createdAt = dic[Constants.FStore.createdAtField] as! Timestamp
    }
    
}
