//
//  BaseViewController.swift
//  Digitalent
//
//  Created by Teke on 16/10/20.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {

    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
    
    func getRequest(url: String, tag: String){
        AF.request("\(DigitalentURL.BASE_URL)\(url)",
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default).responseData { response in
                    debugPrint(response)
                    switch response.result {
                        case .success(let data):
                            self.onSuccess(data: data, tag: tag)
                            break
                        case .failure(_):
                            self.onFailed(tag: tag)
                            break
                        }
                   }
    }
    
    func postRequest(url: String, parameters: [String:Any], tag: String){
        
        AF.request("\(DigitalentURL.BASE_URL)\(url)",
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.httpBody).responseData { response in
                    debugPrint(response)
                    switch response.result {
                    case .success(let data):
                        self.onSuccess(data: data, tag: tag)
                        break
                    case .failure(_):
                        self.onFailed(tag: tag)
                        break
                    }
        }
    }
    
    func onSuccess(data: Data, tag: String){}
    
    func onFailed(tag: String){
        debugPrint("Error Get Request \(tag)")
    }

}

extension UIViewController {
    func saveStringPreference(value: String, key: String){
        let preferences = UserDefaults.standard
        preferences.set(value, forKey: key)
        preferences.synchronize()
    }
    
    func readStringPreference(key: String) -> String {
        let preferences = UserDefaults.standard
        return preferences.string(forKey: key) ?? ""
    }
    
    func setTapToHideKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
    func validate(emailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: emailAddress)
    }
}

