//
//  ForgetPassViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 09/11/20.
//

import UIKit

class ForgetPassViewController: BaseViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var resetButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let tap = ForgetPasswordTapGesture(target: self, action: #selector(resetPassword(_:)))
        resetButton.addGestureRecognizer(tap)
    }

    @objc func resetPassword(_ sender: ForgetPasswordTapGesture?) {
        let email = emailText.text ?? ""
        if email.isEmpty{
            let alert = UIAlertController(title: "Error", message: "Please input your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let parameter:[String:Any] = [
                "email":"\(email)"
            ]
            
            postRequest(url: "api/Resetpass/forgot_password", parameters: parameter, tag: "post reset pass")
            
            let alert = UIAlertController(title: "", message: "Please check your email to reset password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
    }
    
    override func onSuccess(data: Data, tag: String) {
        
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
