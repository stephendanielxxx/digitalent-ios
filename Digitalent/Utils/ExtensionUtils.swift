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

extension UIViewController{
    func embed(_ viewController:UIViewController, inParent controller:UIViewController, inView view:UIView){
        viewController.willMove(toParent: controller)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        controller.addChild(viewController)
        viewController.didMove(toParent: controller)
    }
}

extension UITextView {
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
    
}

class BottomBorderTF: UITextField {
    
    var bottomBorder = UIView()
    override func awakeFromNib() {
        
        //MARK: Setup Bottom-Border
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor.lightGray
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
        
        addTarget(self, action: #selector(activeTextFieldColor), for: .editingDidBegin)
        addTarget(self, action: #selector(deactiveTextFieldColor), for: .editingDidEnd)
    }
    
    @objc func activeTextFieldColor(){
        bottomBorder.backgroundColor = UIColor.blue
    }
    @objc func deactiveTextFieldColor(){
        bottomBorder.backgroundColor = UIColor.lightGray
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
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToAttributedStringAnswer: NSAttributedString? {
        let htmlTemplate = """
           <!doctype html>
           <html>
             <head>
               <style>
                 body {
                   font-family: -apple-system;
                   font-size: 12px;
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
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToAttributedStringWhite: NSAttributedString? {
        let htmlTemplate = """
           <!doctype html>
           <html>
             <head>
               <style>
                 body {
                   font-family: -apple-system;
                   font-size: 14px;
                   color: white;
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
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
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
    
    var generateTransactionId: String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmmss"
        return "\(dateFormatter.string(from: date))\(self)"
    }
}
