//
//  ClassContentViewController.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit

class ClassContentViewController: BaseViewController {
    var course_id = ""
    var detailClassModel: GetOnlineClassDetailModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibClass = UINib(nibName: "ClassContentTableViewCell", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "classContentIdentifier")
        
        let requestUrl = "online/get_detail_course/\(course_id)"
        getRequest(url: requestUrl, tag: "get course detail")
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        
        if tag == "get course detail" {
            do{
                self.detailClassModel = try decoder.decode(GetOnlineClassDetailModel.self, from:data)
                
                self.tableView.reloadData()
            }catch{
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ClassContentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailClassModel?.materi.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classContentIdentifier") as! ClassContentTableViewCell
        let materi = detailClassModel.materi[indexPath.row]
        cell.materialTitle.text = materi.material
        cell.subMaterialTitle.text = materi.submaterial
        
        if materi.video != nil {
            cell.videoIcon.isHidden = false
        }
        
        if materi.materialID != nil {
            cell.quizIcon.isHidden = false
        }
        
        if materi.pdf != nil {
            cell.pdfIcon.isHidden = false
        }
        
        return cell
    }
}
