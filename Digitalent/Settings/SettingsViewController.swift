
import UIKit
import Alamofire
import PopupDialog

class SettingsViewController: BaseViewController, DeleteDialogDelegate{
    
    
    @IBOutlet weak var settingsAccount: UILabel!
    @IBOutlet weak var settingsSecurity: UILabel!
    @IBOutlet weak var settingsNotification: UILabel!
    @IBOutlet weak var deleteAccount: UILabel!
    @IBOutlet weak var settingsSignout: UILabel!
    @IBOutlet weak var LogOut: UILabel!
    
    // var delegate: SettingDelegate!
    
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
        showCustomDialog(animated: true)
    }
    
    func showCustomDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let ratingVC = DeleteDialogViewController(nibName: "DeleteDialogViewController", bundle: nil)
        ratingVC.delegate = self
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        
        present(popup, animated: animated, completion: nil)
    }
    
    func onDeleteAccount(){
        
        let parameters: [String: Any] = [
            "id": "\(readStringPreference(key: DigitalentKeys.ID))"
        ]
        postRequest(url: "api/apidelete", parameters: parameters, tag: "delete account")
        
    }
    
    override func onSuccess(data: Data, tag: String) {
        
        let Decoder = JSONDecoder()
        if tag == "delete account" {
            
            do {
                let deleteModel = try Decoder.decode(DeleteModel.self, from: data)
                if deleteModel.info == "Delete Success" {
                    let alert = UIAlertController(title: "Delete Success", message: "\(deleteModel.message)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else{
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
}

