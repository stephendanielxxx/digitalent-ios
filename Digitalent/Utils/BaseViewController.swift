//
//  BaseViewController.swift
//  Digitalent
//
//  Created by Teke on 16/10/20.
//

import UIKit
import Alamofire

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getRequest(url: String, tag: String){
        AF.request("\(DigitalentURL.BASE_URL)\(url)",
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default).responseData { response in
                    
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
