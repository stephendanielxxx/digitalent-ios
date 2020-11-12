//
//  BaseSettingViewController.swift
//  Digilearn_001
//
//  Created by Teke on 25/09/20.
//  Copyright © 2020 Digimaster. All rights reserved.
//

import UIKit
import Alamofire

class BaseSettingsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showErrorAlert(title: String, errorMessage: String){
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showErrorAlert(title: String, errorMessage: String, handler:((UIAlertAction) -> Void)?){
           let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Close", style: .default, handler: handler))
           self.present(alert, animated: true)
       }
    
    func signout(){
        let user_email = readStringPreference(key: DigitalentKeys.ID)
        
        let URL = "\(DigitalentURL.BASE_URL)/user/auth/logout"
        
        let parameters: [String:Any] = [
            "email": "\(user_email)"
        ]
        
        self.showSpinner(onView: self.view)
        AF.request(URL,
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.httpBody).responseData { response in
                    switch response.result {
                    case .success(let data):
                        self.removeSpinner()
                        let decoder = JSONDecoder()
                        do{
                            _ = try decoder.decode(SignoutModel.self, from:data)
                            
                            self.saveStringPreference(value: "", key: DigitalentKeys.ID)
                            self.saveStringPreference(value: "", key: DigitalentKeys.FIRST_NAME)
                            self.saveStringPreference(value: "", key: DigitalentKeys.LAST_NAME)
                            self.saveStringPreference(value: "", key: DigitalentKeys.ADDRESS)
                            self.saveStringPreference(value: "", key: DigitalentKeys.EMAIL)
                            self.saveStringPreference(value: "", key: DigitalentKeys.PHONE)
                            self.saveStringPreference(value: "", key: DigitalentKeys.BIRTH_DATE)
                            self.saveStringPreference(value: "", key: DigitalentKeys.GENDER)
                            self.saveStringPreference(value: "", key: DigitalentKeys.USER_PHOTO)
                            
//                            self.resetDefaults()
                            
                            self.dismiss(animated: true, completion: {
                                let login = LoginViewController()
                                login.modalPresentationStyle = .fullScreen
                                self.present(login, animated: true, completion: nil)
                            })
                            
                        }catch{
                            print(error.localizedDescription)
                        }
                    case .failure(_):
                        self.removeSpinner()
                    }
        }
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

