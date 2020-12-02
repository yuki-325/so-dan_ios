//
//  UIColorExtension.swift
//  so-dan_app
//
//  Created by 中野勇貴 on 2020/12/02.
//

import UIKit

extension UIColor {
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}


