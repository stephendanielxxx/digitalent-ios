//
//  SecurityViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 26/10/20.
//

import UIKit
import Alamofire

class SecurityViewController: BaseSettingsViewController {
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func backButton(_ sender: Any) {
        
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let oldPass = readStringPreference(key: DigitalentKeys.PASSWORD)
        if oldPassword.text?.count ?? 0 == 0 {
            let alert = UIAlertController(title: "Change Password Failed", message: "Please filled your password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if oldPassword.text != oldPass {
            let alert = UIAlertController(title: "Change Password Failed", message: "Your old password is INCORRECT. Pelase try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if newPassword.text?.count ?? 0 < 6{
            let alert = UIAlertController(title: "Change Password Failed", message: "Password must be 6 character or more", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if confirmPassword.text?.count ?? 0 < 6{
            let alert = UIAlertController(title: "Change Password Failed", message: "Password must be 6 character or more", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else if newPassword.text != confirmPassword.text {
            let alert = UIAlertController(title: "Change Password Failed", message: "Confirm password not same with new password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }else{
            changePassword(oldPassword: oldPassword.text!, newPassword: newPassword.text!)
        }
    }
    
    override func onSuccess(data: Data, tag: String) {
        super.onSuccess(data: data, tag: tag)
        
        self.removeSpinner()
        
        let decoder = JSONDecoder()
        do{
            let response = try decoder.decode(DeleteModel.self, from:data)
            
            self.showErrorAlert(title: response.message, errorMessage: response.message)
            
            if response.info.caseInsensitiveCompare("Updated Success") == .orderedSame {
                self.logout()
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String){
        let user_id = readStringPreference(key: DigitalentKeys.ID)
            
        let parameters: [String:Any] = [
            "id": "\(user_id)",
            "password": "\(newPassword)"
        ]
    
        putRequest(url: "api/apiupdatepassword", parameters: parameters, tag: "post update pass")
        
        self.showSpinner(onView: self.view)
    }
  
}
