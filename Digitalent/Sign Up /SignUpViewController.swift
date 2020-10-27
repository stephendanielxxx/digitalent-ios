

import UIKit
import Alamofire



class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var retypepassText: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var passwordIcon: UIButton!
    @IBOutlet weak var passwordIconn: UIButton!
    
    
    var SignupModel: SignupModel!
    var iconClick = true
    var emailValid = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func signInButton(_ sender: UIButton) {
        
            let signin = LoginViewController()
            signin.modalPresentationStyle = .fullScreen
            self.present(signin, animated: true, completion: nil)
        
    }
    @IBAction func signUpButton(_ sender: UIButton) {

        let parameters: [String:Any] = [
            "email": "\(emailText.text!)",
            "password": "\(passwordText.text!)"
        ]
        postRequest(url: "user/auth/create_user", parameters: parameters, tag: "post sign up")
        
    }
    
    @IBAction func passwordClick(_ sender: UIButton) {
        if(iconClick == true) {
            passwordText.isSecureTextEntry = false
            passwordIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        } else {
            passwordText.isSecureTextEntry = true
            passwordIcon.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        
        iconClick = !iconClick

    }
    
    @IBAction func retypepassClick(_ sender: UIButton) {
        if(iconClick == true) {
            passwordText.isSecureTextEntry = false
            passwordIconn.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        } else {
            passwordText.isSecureTextEntry = true
            passwordIconn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        
        iconClick = !iconClick

    }
    
    
}
