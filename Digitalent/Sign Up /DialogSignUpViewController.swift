//
//  DialogSignUpViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 24/11/20.
//

import UIKit

class DialogSignUpViewController: UIViewController {
    var delegate: DialogSignUp!

    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    @IBAction func closeAction(_ sender: Any) {
        self.delegate.onclose()
    }

}
protocol DialogSignUp {
    func onclose()
}
