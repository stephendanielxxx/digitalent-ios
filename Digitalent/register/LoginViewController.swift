//
//  LoginViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 19/10/20.
//

import UIKit


class LoginViewController: BaseViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgetButton: UILabel!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var passwordIcon: UIButton!
    
    var loginModel: LoginModel!
    var iconClick = true
    var emailValid = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func signIn(_ sender: UIButton) {
        let parameters: [String:Any] = [
            "email": "\(emailText.text!)",
            "password": "\(passwordText.text!)"
        ]
        postRequest(url: "user/auth/login", parameters: parameters, tag: "post login")
        
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
            do{
                self.loginModel = try decoder.decode(LoginModel.self, from:data)
                if self.loginModel.user != nil{
                    self.saveStringPreference(value: (loginModel.user?[0].id)!, key: DigitalentKeys.ID)
                    self.saveStringPreference(value: (loginModel.user?[0].firstName)!, key: DigitalentKeys.FIRST_NAME)
                    self.saveStringPreference(value: (loginModel.user?[0].lastName)!, key: DigitalentKeys.LAST_NAME)
                    self.saveStringPreference(value: (loginModel.user?[0].address)!, key: DigitalentKeys.ADDRESS)
                    self.saveStringPreference(value: (loginModel.user?[0].province)!, key: DigitalentKeys.PROVINCE)
                    self.saveStringPreference(value: (loginModel.user?[0].city)!, key: DigitalentKeys.CITY)
                    self.saveStringPreference(value: (loginModel.user?[0].poscode)!, key: DigitalentKeys.POSCODE)
                    self.saveStringPreference(value: (loginModel.user?[0].kelas)!, key: DigitalentKeys.KELAS)
                    self.saveStringPreference(value: (loginModel.user?[0].lastEducation)!, key: DigitalentKeys.LAST_EDUCATION)
                    self.saveStringPreference(value: (loginModel.user?[0].selectJob)!, key: DigitalentKeys.SELECT_JOB)
                    self.saveStringPreference(value: (loginModel.user?[0].institution)!, key: DigitalentKeys.INSTITUTION)
                    self.saveStringPreference(value: (loginModel.user?[0].email)!, key: DigitalentKeys.EMAIL)
                    self.saveStringPreference(value: (loginModel.user?[0].gender)!, key: DigitalentKeys.GENDER)
                    self.saveStringPreference(value: (loginModel.user?[0].birthDate)!, key: DigitalentKeys.BIRTH_DATE)
                    self.saveStringPreference(value: (loginModel.user?[0].phone)!, key: DigitalentKeys.PHONE)
                    self.saveStringPreference(value: (loginModel.user?[0].tempatlahir)!, key: DigitalentKeys.TEMPAT_LAHIR)
                    self.saveStringPreference(value: (loginModel.user?[0].userPhoto)!, key: DigitalentKeys.USER_PHOTO)
                    self.saveStringPreference(value: (loginModel.user?[0].userPhotoStatus)!, key: DigitalentKeys.USER_PHOTO_STATUS)
                    self.saveStringPreference(value: (loginModel.user?[0].userProfile)!, key: DigitalentKeys.USER_PROFILE)
                    self.saveStringPreference(value: (loginModel.user?[0].about)!, key: DigitalentKeys.ABOUT)
                    self.saveStringPreference(value: (loginModel.user?[0].isTeacher)!, key: DigitalentKeys.IS_TEACHER)
                
                    let home = HomeTabBarViewController()
                    home.modalPresentationStyle = .fullScreen
                    self.present(home, animated: true, completion: nil)

                }
                else {
                        let alert = UIAlertController(title: "Login Failed", message: "\(loginModel.message)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                        self.present(alert, animated: true)
                }

            }catch{
                print(error.localizedDescription)
            }
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
            let signup = SignUpViewController()
            signup.modalPresentationStyle = .fullScreen
            self.present(signup, animated: true, completion: nil)
    }
    
    @IBAction func passwordIconClick(_ sender: UIButton) {
        
            if(iconClick == true) {
                passwordText.isSecureTextEntry = false
                passwordIcon.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
                
            } else {
                passwordText.isSecureTextEntry = true
                passwordIcon.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            }
            
            iconClick = !iconClick
    }
    
}
