//
//  AllOnlineClassViewController.swift
//  Digitalent
//
//  Created by Teke on 20/10/20.
//

import UIKit

class AllOnlineClassViewController: BaseViewController {
    
    @IBOutlet weak var onlineClassView: UICollectionView!
    var onlineClassModel: OnlineClassModel!
    var cellMarginSize = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibClass = UINib(nibName: "OnlineClassCollectionViewCell", bundle: nil)
        onlineClassView.register(nibClass, forCellWithReuseIdentifier: "onlineClassIdentifier")
        
        onlineClassView.delegate = self
        onlineClassView.dataSource = self
        
        getRequest(url: "home/get_online_course_all", tag: "get all online class")
        
        setupGridView()
    }
    
    func setupGridView(){
        let flow = onlineClassView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = 8
        flow.minimumLineSpacing = 16
    }
    
    override func onSuccess(data: Data, tag: String) {
        do{
            let decoder = JSONDecoder()
            self.onlineClassModel = try decoder.decode(OnlineClassModel.self, from:data)
            
            self.onlineClassView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AllOnlineClassViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onlineClassModel?.online.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onlineClassIdentifier", for: indexPath) as! OnlineClassCollectionViewCell
        
        let onlineClass: OnlineModel = onlineClassModel.online[indexPath.row]
        
        cell.onlineClassImage.pin_updateWithProgress = true
        cell.onlineClassImage.layer.cornerRadius = 15
        cell.onlineClassImage.contentMode = .scaleToFill
        cell.onlineClassImage.clipsToBounds = true
        
        let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_CLASS)\(onlineClass.image)")!
        
        cell.onlineClassImage.pin_setImage(from: url)
        
        cell.onlineClassLabel.text = onlineClass.title
        
        let tap = ClassDetailTapGesture(target: self, action: #selector(selectCourse(_:)))
        tap.courseId = onlineClass.id
        tap.totalVideo = onlineClass.totalVideo
        tap.totalQuiz = onlineClass.totalQuiz
        tap.totalPdf = onlineClass.totalPdf
        cell.baseView.addGestureRecognizer(tap)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: 200)
        
    }
    
    func calculateWidth() -> CGFloat{
        let cellCount = CGFloat(2)
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
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
