//
//  MyClassViewController.swift
//  Digitalent
//
//  Created by Teke on 21/10/20.
//

import UIKit

class MyClassViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    var myClassModel: MyClassModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibClass = UINib(nibName: "MyClassTableViewCell", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "myClassIdentifier")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            
            emptyImage.isHidden = true
            tableView.isHidden = false
            
            self.tableView.reloadData()
        }catch{
            emptyImage.isHidden = false
            tableView.isHidden = true
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
        
        cell.classDeadline.text = "Finished this class before: \(myClass.expiredAt?.parseDateToString ?? "")"
        
        cell.classItem.text = "Videos \(myClass.totalVideo!)    |    Quizes \(myClass.totalQuiz!)    |    Pdfs \(myClass.totalPDF!)"
        
        let tap = ClassDetailTapGesture(target: self, action: #selector(selectCourse(_:)))
        tap.courseId = myClass.courseID
        tap.totalVideo = myClass.totalVideo
        tap.totalQuiz = myClass.totalQuiz
        tap.totalPdf = myClass.totalPDF
        cell.baseVIew.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func selectCourse(_ sender: ClassDetailTapGesture?) {
        let courseId = sender!.courseId!
        let totalVideo = sender!.totalVideo!
        let totalQuiz = sender!.totalQuiz!
        let totalPdf = sender!.totalPdf!
       
        let detailClass = OnlineClassDetailViewController()
        detailClass.courseId = courseId
        detailClass.totalVideo = totalVideo
        detailClass.totalQuiz = totalQuiz
        detailClass.totalPdf = totalPdf
        detailClass.modalPresentationStyle = .fullScreen
        present(detailClass, animated: true, completion: nil)
    }
    
}
