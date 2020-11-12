//
//  FinishQuizViewController.swift
//  Digitalent
//
//  Created by Teke on 12/11/20.
//

import UIKit

class FinishQuizViewController: UIViewController {

    @IBOutlet weak var backAction: UIButton!
    
    var delegate: FinishQuizDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        backAction.layer.cornerRadius = 16
    }

    @IBAction func backAction(_ sender: UIButton) {
        delegate.onFinish()
    }
}

protocol FinishQuizDelegate {
    func onFinish()
}
