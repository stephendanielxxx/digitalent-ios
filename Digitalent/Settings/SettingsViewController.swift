
import UIKit
import Alamofire

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsAccount: UILabel!
    @IBOutlet weak var settingsSecurity: UILabel!
    @IBOutlet weak var settingsNotification: UILabel!
    @IBOutlet weak var deleteAccount: UILabel!
    @IBOutlet weak var settingsSignout: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let setAccount = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.openSettingsAccount))
        settingsAccount.isUserInteractionEnabled = true
        settingsAccount.addGestureRecognizer(setAccount)
        
        let setSecurity = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.openSecurity))
        settingsSecurity.isUserInteractionEnabled = true
        settingsSecurity.addGestureRecognizer(setSecurity)
        
        let deleteAccountGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.openDeleteAccount))
        deleteAccount.isUserInteractionEnabled = true
        deleteAccount.addGestureRecognizer(deleteAccountGesture)
        

    }

    @objc func openSettingsAccount(sender:UITapGestureRecognizer) {
        let changePass = AccountViewController()
        
        changePass.modalPresentationStyle = .fullScreen
        
        self.present(changePass, animated: true, completion: nil)
    }
    
    
    @objc func openSecurity(sender:UITapGestureRecognizer) {
        let changePass = SecurityViewController()
        
        changePass.modalPresentationStyle = .fullScreen
        
        self.present(changePass, animated: true, completion: nil)
    }
  
    
    @objc func openDeleteAccount(sender:UITapGestureRecognizer) {
        let changePass = SecurityViewController()
        
        changePass.modalPresentationStyle = .fullScreen
        
        self.present(changePass, animated: true, completion: nil)
    }
}
