//
//  MyClassTableViewCell.swift
//  Digitalent
//
//  Created by Teke on 21/10/20.
//

import UIKit

class MyClassTableViewCell: UITableViewCell {

    @IBOutlet weak var baseVIew: UIView!
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var classDeadline: UILabel!
    @IBOutlet weak var classItem: UILabel!
    @IBOutlet weak var classProgress: UIProgressView!
    @IBOutlet weak var classPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        classImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
