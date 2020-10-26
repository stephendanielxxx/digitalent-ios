//
//  SearchResultViewController.swift
//  Digitalent
//
//  Created by Teke on 21/10/20.
//

import UIKit

class SearchResultViewController: BaseViewController {

    @IBOutlet weak var onlineClassView: UICollectionView!
    @IBOutlet weak var emptyImage: UIImageView!
    var searchClassModel: SearchClassModel!
    var cellMarginSize = 16.0
    var textSearched = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibClass = UINib(nibName: "OnlineClassCollectionViewCell", bundle: nil)
        onlineClassView.register(nibClass, forCellWithReuseIdentifier: "onlineClassIdentifier")
        
        onlineClassView.delegate = self
        onlineClassView.dataSource = self
        
        let parameters: [String:Any] = [
            "course_title": "\(textSearched)"
        ]
        postRequest(url: "home/get_search", parameters: parameters, tag: "post search class")
        
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
            self.searchClassModel = try decoder.decode(SearchClassModel.self, from:data)
            if self.searchClassModel.data.count > 0 {
                emptyImage.isHidden = true
                onlineClassView.isHidden = false
                self.onlineClassView.reloadData()
            }else{
                emptyImage.isHidden = false
                onlineClassView.isHidden = true
            }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchClassModel?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onlineClassIdentifier", for: indexPath) as! OnlineClassCollectionViewCell
            
            let searchData: SearchDataModel = searchClassModel.data[indexPath.row]
            
            cell.onlineClassImage.pin_updateWithProgress = true
            cell.onlineClassImage.layer.cornerRadius = 15
            cell.onlineClassImage.contentMode = .scaleToFill
            cell.onlineClassImage.clipsToBounds = true
            
            let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_CLASS)\(searchData.courseImage)")!
            
            cell.onlineClassImage.pin_setImage(from: url)
            
            cell.onlineClassLabel.text = searchData.courseTitle
            
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
}
