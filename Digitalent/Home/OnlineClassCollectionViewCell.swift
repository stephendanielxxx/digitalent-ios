//
//  OnlineClassCollectionViewCell.swift
//  Digitalent
//
//  Created by Teke on 19/10/20.
//

import UIKit
import MaterialComponents.MDCCard

class OnlineClassCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: MDCCard!
    @IBOutlet weak var onlineClassImage: UIImageView!
    @IBOutlet weak var onlineClassLabel: UILabel!
    @IBOutlet weak var cardView: MDCCard!
    override func awakeFromNib() {
        super.awakeFromNib()
        onlineClassImage.layer.cornerRadius = 15
        cardView.cornerRadius = 20
    }

}
