//
//  ClassContentViewController.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit

class ClassContentViewController: BaseViewController {
    var course_id = ""
    var transactionId = ""
    var detailClassModel: GetOnlineClassDetailModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibClass = UINib(nibName: "ClassContentTableViewCell", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "classContentIdentifier")
        
        let userId = readStringPreference(key: DigitalentKeys.ID)
        let requestUrl = "online/get_detail_course/\(course_id)/\(userId)"
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
            
            let tapVideo = ClassContentTapGesture(target: self, action: #selector(openVideo(_:)))
            tapVideo.video = materi.video!
            cell.videoIcon.addGestureRecognizer(tapVideo)
        }
        
        if materi.materialID != nil {
            cell.quizIcon.isHidden = false
            
            let tapQuiz = ClassContentTapGesture(target: self, action: #selector(openQuiz(_:)))
            tapQuiz.quiz = materi.materialID!
            tapQuiz.subMaterial = materi.submaterial!
            tapQuiz.quiz_duration = materi.quizDuration
            cell.quizIcon.addGestureRecognizer(tapQuiz)
        }
        
        if materi.pdf != nil {
            cell.pdfIcon.isHidden = false
            
            let tapPdf = ClassContentTapGesture(target: self, action: #selector(openPdf(_:)))
            tapPdf.pdf = materi.pdf!
            cell.pdfIcon.addGestureRecognizer(tapPdf)
        }
        
        return cell
    }
    
    @objc func openVideo(_ sender: ClassContentTapGesture?) {
        let video = sender!.video
        let openVideo = MaterialVideoViewController()
        openVideo.video = video
        openVideo.modalPresentationStyle = .fullScreen
        present(openVideo, animated: true, completion: nil)
    }
    
    @objc func openPdf(_ sender: ClassContentTapGesture?) {
        let pdf = sender!.pdf
        
        let openPdf = MaterialPdfViewController()
        openPdf.pdf = pdf
        openPdf.modalPresentationStyle = .fullScreen
        present(openPdf, animated: true, completion: nil)
    }
    
    @objc func openQuiz(_ sender: ClassContentTapGesture?) {
        let quiz = sender!.quiz
        let submaterial = sender!.subMaterial
        let duration = sender!.quiz_duration
        let openQuiz = QUizViewController()
        openQuiz.quiz_duration = duration
        openQuiz.course_id = course_id
        openQuiz.submaterial = submaterial
        openQuiz.material_id = quiz
        openQuiz.transactionId = transactionId
        openQuiz.modalPresentationStyle = .fullScreen
        present(openQuiz, animated: true, completion: nil)
    }
}
