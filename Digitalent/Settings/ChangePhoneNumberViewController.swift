//
//  ChangePhoneNumberViewController.swift
//  Digitalent
//
//  Created by Seraphina Tatiana   on 11/11/20.
//

import UIKit
import Alamofire

class ChangePhoneNumberViewController: BaseViewController {
    @IBOutlet weak var changeNumber: UITextField!
    @IBOutlet weak var saveAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let number = readStringPreference(key: DigitalentKeys.PHONE)
        changeNumber.text = number
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveChangePhoneNumber (_ sender: Any) {
        
        let parameters: [String: Any] = [
            "id": "\(readStringPreference(key: DigitalentKeys.ID))",
            "phone": "\(changeNumber.text!)"
            
        ]
        
        putRequest(url: "api/apiupdatephone", parameters: parameters, tag: "change phone number")

    }
    
    override func onSuccess(data: Data, tag: String) {
        let Decoder = JSONDecoder()
        if tag == "change phone number" {
        
            do {
                let phoneModel = try Decoder.decode(PhoneModel.self, from: data)
                if phoneModel.info == "Updated Failed" {
                            let alert = UIAlertController(title: "Updated Failed", message: "Try Again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                            self.present(alert, animated: true)
                }
                
                else{
                    saveStringPreference(value: changeNumber.text! , key: DigitalentKeys.PHONE )
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

