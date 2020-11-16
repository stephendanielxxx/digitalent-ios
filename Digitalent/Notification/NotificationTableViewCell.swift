//
//  NotificationTableViewCell.swift
//  Digitalent
//
//  Created by Teke on 20/10/20.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var notifImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
