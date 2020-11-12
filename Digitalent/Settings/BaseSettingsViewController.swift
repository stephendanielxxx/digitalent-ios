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
    
    func logout(){
        let parameters: [String: Any] = [
            "email": "\(readStringPreference(key: DigitalentKeys.EMAIL))"
        ]
        postRequest(url: "user/auth/logout", parameters: parameters, tag: "logout")
    }
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        do{
            _ = try decoder.decode(SignoutModel.self, from:data)
            
            self.saveStringPreference(value: "", key: DigitalentKeys.ID)
            self.saveStringPreference(value: "", key: DigitalentKeys.PASSWORD)
            self.saveStringPreference(value: "", key: DigitalentKeys.FIRST_NAME)
            self.saveStringPreference(value: "", key: DigitalentKeys.LAST_NAME)
            self.saveStringPreference(value: "", key: DigitalentKeys.ADDRESS)
            self.saveStringPreference(value: "", key: DigitalentKeys.PROVINCE)
            self.saveStringPreference(value: "", key: DigitalentKeys.CITY)
            self.saveStringPreference(value: "", key: DigitalentKeys.POSCODE)
            self.saveStringPreference(value: "", key: DigitalentKeys.KELAS)
            self.saveStringPreference(value: "", key: DigitalentKeys.LAST_EDUCATION)
            self.saveStringPreference(value: "", key: DigitalentKeys.SELECT_JOB)
            self.saveStringPreference(value: "", key: DigitalentKeys.INSTITUTION)
            self.saveStringPreference(value: "", key: DigitalentKeys.USER_PROFILE)
            self.saveStringPreference(value: "", key: DigitalentKeys.EMAIL)
            self.saveStringPreference(value: "", key: DigitalentKeys.GENDER)
            self.saveStringPreference(value: "", key: DigitalentKeys.BIRTH_DATE)
            self.saveStringPreference(value: "", key: DigitalentKeys.PHONE)
            self.saveStringPreference(value: "", key: DigitalentKeys.TEMPAT_LAHIR)
            self.saveStringPreference(value: "", key: DigitalentKeys.USER_PHOTO)
            self.saveStringPreference(value: "", key: DigitalentKeys.USER_PHOTO_STATUS)
            self.saveStringPreference(value: "", key: DigitalentKeys.USER_PROFILE)
            self.saveStringPreference(value: "", key: DigitalentKeys.ABOUT)
            self.saveStringPreference(value: "", key: DigitalentKeys.IS_TEACHER)
            
            self.dismiss(animated: true, completion: {
                let login = LoginViewController()
                login.modalPresentationStyle = .fullScreen
                self.present(login, animated: true, completion: nil)
            })
            
        }catch{
            print(error.localizedDescription)
        }
    }
}

