//
//  ExtensionUtils.swift
//  Digitalent
//
//  Created by Teke on 15/10/20.
//

import Foundation
import UIKit

extension UIImageView {

    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.contentMode = .scaleToFill
    }
    
    func makeRoundedWithBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.contentMode = .scaleToFill
    }
}
