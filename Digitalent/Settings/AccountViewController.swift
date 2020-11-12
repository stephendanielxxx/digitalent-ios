

import UIKit


class AccountViewController: UIViewController {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        let email = readStringPreference(key: DigitalentKeys.EMAIL)
        emailText.text = email
        let number = readStringPreference(key: DigitalentKeys.PHONE)
        changeNumber.text = number
     
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
        
    }
    

}
