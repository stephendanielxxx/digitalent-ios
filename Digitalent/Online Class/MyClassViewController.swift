//
//  MyClassViewController.swift
//  Digitalent
//
//  Created by Teke on 21/10/20.
//

import UIKit

class MyClassViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var myClassModel: MyClassModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibClass = UINib(nibName: "MyClassTableViewCell", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "myClassIdentifier")
        
        let userId = readStringPreference(key: DigitalentKeys.ID)
        let parameters: [String:Any] = [
            "uid": "\(userId)"
        ]
        postRequest(url: "onsite/ambilPerUser", parameters: parameters, tag: "post my class")
    }
    
    override func onSuccess(data: Data, tag: String) {
        do{
            let decoder = JSONDecoder()
            self.myClassModel = try decoder.decode(MyClassModel.self, from:data)
            
            self.tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
}

extension MyClassViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myClassModel?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myClassIdentifier") as! MyClassTableViewCell
        
        let myClass: ClassDataModel = (myClassModel?.data[indexPath.row])!
        
        cell.classTitle.text = myClass.courseTitle!
        
        cell.classImage.pin_updateWithProgress = true
        cell.classImage.layer.cornerRadius = 15
        cell.classImage.contentMode = .scaleToFill
        cell.classImage.clipsToBounds = true
        
        let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_CLASS)\(myClass.courseImage!)")!
        
        cell.classImage.pin_setImage(from: url)
        
        let total = Float(myClass.videosu!)! * 3
        
        let totalVideo = Float(myClass.totalVideo!)
        let totalQuiz = Float(myClass.totalQuiz!)
        let totalPdf = Float(myClass.totalPDF!)
        
        let totalAll = totalVideo! + totalQuiz! + totalPdf!
        let percent = totalAll * 100
        if percent == 0 {
            cell.classProgress.setProgress(Float(totalAll), animated: true)
            cell.classPercentage.text = "\(Int(totalAll))%"
        }else{
            let percentage = percent / total
            cell.classPercentage.text = "\(Int(percentage))%"
            cell.classProgress.setProgress(Float(percentage / 100), animated: true)
        }
        
        cell.classItem.text = "Videos \(myClass.videosu!)    |    Quizes \(myClass.videosu!)    |    Pdfs \(myClass.videosu!)"
        
        return cell
    }
}
