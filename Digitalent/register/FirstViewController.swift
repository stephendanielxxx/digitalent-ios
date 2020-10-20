//
//  FirstViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 15/10/20.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signInButton(_ sender: UIButton) {
        let login = LoginViewController()
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true, completion: nil)
    }


    @IBAction func signUpButton(_ sender: UIButton) {
        let signup = SignUpViewController()
        signup.modalPresentationStyle = .fullScreen
        self.present(signup, animated: true, completion: nil)
    }
}

