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
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        backAction.layer.cornerRadius = 16
    }

    @IBAction func backAction(_ sender: UIButton) {
        delegate.onFinish(score: score)
    }
}

protocol FinishQuizDelegate {
    func onFinish(score: Int)
}
