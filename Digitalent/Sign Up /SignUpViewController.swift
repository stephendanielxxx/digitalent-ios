

import UIKit
import Alamofire


class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var retypepassText: UITextField!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var passwordIcon: UIButton!
    @IBOutlet weak var passwordIconn: UIButton!
    
    var confirmPass = true
    var passClick = true
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
        
        let email = emailText.text!
        let password = passwordText.text!
        
        if email.isEmpty{
            let alert = UIAlertController(title: "Error", message: "Please input your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if password.isEmpty{
            let alert = UIAlertController(title: "Error", message: "Please input your password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            let parameters: [String:Any] = [
                "email": "\(emailText.text!)",
                "password": "\(passwordText.text!)"
            ]
            postRequest(url: "user/auth/create_user", parameters: parameters, tag: "post sign up")
        }
        
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        do {
            let signUpModel = try decoder.decode(SignupModel.self, from: data)
            if signUpModel.code == "200" {
                let alert = UIAlertController(title: "Success", message: "Register success. Please check your email to activate your account.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "Error", message: "\(signUpModel.message)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func passwordClick(_ sender: UIButton) {
        if(passClick == true) {
            passwordText.isSecureTextEntry = false
            passwordIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        } else {
            passwordText.isSecureTextEntry = true
            passwordIcon.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        
        passClick = !passClick
        
    }
    
    @IBAction func retypepassClick(_ sender: UIButton) {
        if(confirmPass == true) {
            retypepassText.isSecureTextEntry = false
            passwordIconn.setImage(UIImage(systemName: "eye.slash.fill"), for:.normal)
            
        } else {
            retypepassText.isSecureTextEntry = true
            passwordIconn.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        confirmPass = !confirmPass
    }
    
    
}
