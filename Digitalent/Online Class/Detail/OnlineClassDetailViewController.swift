//
//  OnlineClassDetailViewController.swift
//  Digitalent
//
//  Created by Teke on 26/10/20.
//

import UIKit
import FittedSheets

class OnlineClassDetailViewController: BaseViewController, UIScrollViewDelegate {

    var courseId = ""
    var totalVideo = ""
    var totalQuiz = ""
    var totalPdf = ""
    
    var detailClassModel: GetOnlineClassDetailModel!
    
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var learNow: UIButton!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseAuthor: UILabel!
    @IBOutlet weak var courseDesc: UITextView!
    @IBOutlet weak var seeAllButotn: UIButton!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var quizCount: UILabel!
    @IBOutlet weak var pdfCount: UILabel!
    @IBOutlet weak var joinClassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let requestUrl = "online/get_detail_course/\(courseId)"
        getRequest(url: requestUrl, tag: "get course detail")
        
        learNow.layer.cornerRadius = 15
        seeAllButotn.layer.cornerRadius = 15
        
    }
    
    fileprivate func showBottomView() {
        let bottomView = ClassBottomSheetViewController()
        
        let options = SheetOptions(
            useInlineMode: true)
        
        let sheetController = SheetViewController(controller: bottomView,
                                              sizes: [.percent(0.75), .fullscreen],
                                              options: options)

        sheetController.willMove(toParent: self)
        self.addChild(sheetController)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)

        sheetController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sheetController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // animate in
        sheetController.animateIn()
    }
    
    @IBAction func showBottom(_ sender: UIButton) {
        showBottomView()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func onSuccess(data: Data, tag: String) {
        do{
            let decoder = JSONDecoder()
            self.detailClassModel = try decoder.decode(GetOnlineClassDetailModel.self, from:data)
            
            loadData(detailModel: self.detailClassModel)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    fileprivate func loadData(detailModel: GetOnlineClassDetailModel){
        
        classImage.pin_updateWithProgress = true
        classImage.contentMode = .scaleToFill
        classImage.clipsToBounds = true
        
        let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_CLASS)\(detailModel.img!)")!
        
        classImage.pin_setImage(from: url)
        
        courseTitle.text = detailModel.title
        courseAuthor.text = "Created By \(detailModel.author)"
        courseDesc.attributedText = detailModel.desc?.htmlToAttributedStringWhite
        
        videoCount.text = totalVideo
        quizCount.text = totalQuiz
        pdfCount.text = totalPdf
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
