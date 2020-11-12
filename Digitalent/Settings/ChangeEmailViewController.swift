//
//  ChangeEmailViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 11/11/20.
//

import UIKit
import Alamofire

class ChangeEmailViewController: BaseViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var saveAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = readStringPreference(key: DigitalentKeys.EMAIL)
        emailText.text = email
        
    }

    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    @IBAction func saveAction(_ sender: Any) {
        let parameters: [String: Any] = [
            "id": "\(readStringPreference(key: DigitalentKeys.ID))",
            "email": "\(emailText.text!)"
            
        ]
        
        putRequest(url: "api/apiupdateemail", parameters: parameters, tag: "change email")

    }
    
    override func onSuccess(data: Data, tag: String) {
        let Decoder = JSONDecoder()
        if tag == "change email" {
        
            do {
                let changeEmailModel = try Decoder.decode(ChangeEmailModel.self, from: data)
                if changeEmailModel.info == "Updated Failed" {
                            let alert = UIAlertController(title: "Change Email Failed", message: "Try Again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                            self.present(alert, animated: true)
                    
                }
                
                else{
                    saveStringPreference(value: emailText.text! , key: DigitalentKeys.EMAIL )
                            let alert = UIAlertController(title: "Updated Success", message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {action in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true)
                            
                    
                }
            }
            catch{
                print(error.localizedDescription)
                }
        }
        
    }
    

}
