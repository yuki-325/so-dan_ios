//
//  Constants.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/28.
//

import UIKit

struct Constants {
    
    static let loginSegueIdentifier = "loginSegue"
    static let signupSegueIdentifier = "signupSegue"
    static let initialVCStoryBordID = "initialView"
    static let adminEmail = "kanrinin@kanrinin.com"
    static let consultationCell = "ConsultationCell"
    static let errorTextColor = UIColor(named: "errorTextColor")!
    
    struct FStore {
        //usersCollection
        static let usersCollection = "users"
        static let usernameField = "username"
        static let emailField = "email"
        
        //consultationCollection
        static let consultationsCollection = "consultations"
        static let titleField = "title"
        static let contentField = "content"
        static let senderEmailField = "senderEmail"
        static let receiverEmailField = "receiverEmail"
        
        //共通
        static let createdAtField = "createdAt"
        
    }
}
