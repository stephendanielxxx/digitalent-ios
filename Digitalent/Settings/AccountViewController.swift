

import UIKit


class AccountViewController: BaseViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var changeNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let setChangeEmail = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.openChangeEmail))
        emailText.isUserInteractionEnabled = true
        emailText.addGestureRecognizer(setChangeEmail)
        
        
        let setChangePhoneNumber = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.openChangePhoneNumber))
        changeNumber.isUserInteractionEnabled = true
        changeNumber.addGestureRecognizer(setChangePhoneNumber)
        
    }
    
    fileprivate func loadData() {
        let email = readStringPreference(key: DigitalentKeys.EMAIL)
        emailText.text = email
        let number = readStringPreference(key: DigitalentKeys.PHONE)
        changeNumber.text = number
        let firstNameValue = readStringPreference(key: DigitalentKeys.FIRST_NAME)
        firstName.text = firstNameValue
        let lastNameValue = readStringPreference(key: DigitalentKeys.LAST_NAME)
        lastName.text = lastNameValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadData()
        
    }
    
    @objc func openChangeEmail(sender:UITapGestureRecognizer) {
        let changePass = ChangeEmailViewController()
        
        changePass.modalPresentationStyle = .fullScreen
        
        self.present(changePass, animated: true, completion: nil)
    }
    
    
    @objc func openChangePhoneNumber(sender:UITapGestureRecognizer) {
        let changePass = ChangePhoneNumberViewController()
        
        changePass.modalPresentationStyle = .fullScreen
        
        self.present(changePass, animated: true, completion: nil)
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        let userId = readStringPreference(key: DigitalentKeys.ID)
        let parameters:[String:Any] = [
            "id":"\(userId)",
            "first_name":"\(firstName.text!)",
            "last_name":"\(lastName.text!)"
        ]
        
        postRequest(url: "user/auth/uploadPic", parameters: parameters, tag: "post update profile")
    }
    
    @IBAction func discardAction(_ sender: UIButton) {
        loadData()
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        do {
            let changeProfileModel = try decoder.decode(ChangeProfileModel.self, from: data)
            if changeProfileModel.code == "200"{
                
                saveStringPreference(value: firstName.text!, key: DigitalentKeys.FIRST_NAME)
                saveStringPreference(value: lastName.text!, key: DigitalentKeys.LAST_NAME)
                
                let alert = UIAlertController(title: "Success", message: "\(changeProfileModel.message)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.loadData()
                }))
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "Error", message: "\(changeProfileModel.message)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }catch{
            print(error.localizedDescription)
        }
    }

    
    
}
