//
//  ClassBottomSheetViewController.swift
//  Digitalent
//
//  Created by Teke on 27/10/20.
//

import UIKit

class ClassBottomSheetViewController: BaseViewController {

    var detailClassModel: GetOnlineClassDetailModel!
    
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseAuthor: UILabel!
    @IBOutlet weak var courseDesc: UITextView!
    @IBOutlet weak var coursePrice: UILabel!
    @IBOutlet weak var participantName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classImage.pin_updateWithProgress = true
        classImage.contentMode = .scaleToFill
        classImage.clipsToBounds = true
        
        let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_CLASS)\(detailClassModel.img!)")!
        
        classImage.pin_setImage(from: url)
        
        courseTitle.text = detailClassModel.title
        courseAuthor.text = "Created By \(detailClassModel.author)"
        courseDesc.attributedText = detailClassModel.desc?.htmlToAttributedString
        coursePrice.text = "Class Price                IDR \(detailClassModel.price!)"
        
    }

    @IBAction func joinAction(_ sender: UIButton) {
        let userName = participantName.text
        if userName != nil && !userName!.isEmpty {
            
            let userId = readStringPreference(key: DigitalentKeys.ID)
            
            let parameters: [String:Any] = [
                "trans_id": "\(userId.generateTransactionId)",
                "uid":"\(userId)",
                "nama_rek":"\(userName!)",
                "cour_id":"\(detailClassModel.courseID)",
                "status":"settlement",
                "total":"\(detailClassModel.price!)",
                "slug":"\(detailClassModel.slug!)"
            ]
            postRequest(url: "online/regis_online", parameters: parameters, tag: "post join class")
        }else {
            let alert = UIAlertController(title: "Failed to Join Class", message: "Please fill Participant Name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        do{
            let joinClassModel = try decoder.decode(JoinClassModel.self, from:data)
            if joinClassModel.code == 100 {
                let alert = UIAlertController(title: "", message: "Terimakasih telah mendaftar. Silahkan menyelesaikan pembayaran, course kamu akan aktif dalam waktu 5 menit setelah melakukan pembayaran.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler:  {(alert: UIAlertAction!) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "", message: "Failed to Join Class. Please try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
