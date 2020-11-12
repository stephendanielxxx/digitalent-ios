//
//  DeleteDialogViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 27/10/20.
//

import UIKit

class DeleteDialogViewController: UIViewController {

    var delegate: DeleteDialogDelegate!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func deleteAction(_ sender: UIButton) {
        delegate.onDeleteAccount()
    }
    
    @IBAction func noButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

protocol DeleteDialogDelegate{
    func onDeleteAccount()
}
