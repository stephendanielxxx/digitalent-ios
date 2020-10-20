//
//  LoginViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 19/10/20.
//

import UIKit


class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgetButton: UILabel!
    @IBOutlet weak var signIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func signIn(_ sender: UIButton) {
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
            let signup = SignUpViewController()
            signup.modalPresentationStyle = .fullScreen
            self.present(signup, animated: true, completion: nil)
    }
    

}
