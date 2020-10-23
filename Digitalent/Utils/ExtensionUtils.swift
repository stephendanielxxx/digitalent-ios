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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        let htmlTemplate = """
           <!doctype html>
           <html>
             <head>
               <style>
                 body {
                   font-family: -apple-system;
                   font-size: 14px;
                 }
               </style>
             </head>
             <body>
               \(self)
             </body>
           </html>
           """
        guard let data = htmlTemplate.data(using: .utf8) else { return nil }
        do {
            let font = UIFont.systemFont(ofSize: 100)
            let attributes = [NSAttributedString.Key.font: font]
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue, .defaultAttributes: attributes], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var parseDateToString: String{
        let dateFormatter = DateFormatter()
        let dateResultFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateResultFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: self)!
        return dateResultFormatter.string(from: date)
    }
}
