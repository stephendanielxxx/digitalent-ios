//
//  ClassContentTableViewCell.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit

class ClassContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var materialTitle: UILabel!
    @IBOutlet weak var subMaterialTitle: UILabel!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var subMaterialView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var videoIcon: UIButton!
    @IBOutlet weak var quizIcon: UIButton!
    @IBOutlet weak var pdfIcon: UIButton!
    @IBOutlet weak var doneIcon: UIImageView!
    @IBOutlet weak var doneHeight: NSLayoutConstraint!
    @IBOutlet weak var doneWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subMaterialView.layer.cornerRadius = 18
        iconView.layer.cornerRadius = 18
        iconView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
    }
    
    @IBAction func rightArrowAction(_ sender: UIButton) {
        //        iconView.isHidden = false
        UIView.transition(with: iconView, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.iconView.isHidden = false
                          })
    }
    
    @IBAction func leftArrowAction(_ sender: UIButton) {
        UIView.transition(with: iconView, duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.iconView.isHidden = true
                          })
        
        
    }
}
