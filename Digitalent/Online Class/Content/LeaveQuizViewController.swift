//
//  LeaveQuizViewController.swift
//  Digitalent
//
//  Created by Teke on 12/11/20.
//

import UIKit

class LeaveQuizViewController: UIViewController {

    var delegate: LeaveQuizDelegate!
    var index: Int!
    var duration = ""
    
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var stayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        leaveButton.layer.cornerRadius = 16
        stayButton.layer.cornerRadius = 16

    }
    
    @IBAction func leaveAction(_ sender: UIButton) {
        delegate.onLeave(index: index, duration: duration)
    }
    
    @IBAction func stayAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

protocol LeaveQuizDelegate {
    func onLeave(index: Int, duration: String)
}
