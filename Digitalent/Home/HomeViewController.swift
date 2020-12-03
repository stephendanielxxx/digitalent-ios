//
//  HomeViewController.swift
//  Digitalent
//
//  Created by Teke on 15/10/20.
//

import UIKit
import ImageSlideshow
import PINRemoteImage
import Gemini

class HomeViewController: BaseViewController, UISearchBarDelegate {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var bannerCollectionView: GeminiCollectionView!
    @IBOutlet weak var onlineClassView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var onlineClassViewHeight: NSLayoutConstraint!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var searchClass: UISearchBar!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    var bannerModel: BannerModel!
    var onlineClassModel: OnlineClassModel!
    var homeProfileModel: HomeProfileModel!
    
    var cellMarginSize = 16.0
    var itemCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageProfile.makeRoundedWithBorder()
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        
        onlineClassView.delegate = self
        onlineClassView.dataSource = self
        
        registerNib()
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        setupGridView()
        
        searchClass.searchTextField.backgroundColor = .clear
        searchClass.layer.cornerRadius = 20
        searchClass.clipsToBounds = true
        
        searchClass.delegate = self
        
        bannerCollectionView.gemini.scaleAnimation().scale(0.85).scaleEffect(.scaleUp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openAccount(_:)))
        imageProfile.isUserInteractionEnabled = true
        imageProfile.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        showSpinner(onView: self.view)
        getRequest(url: "home/get_home_banner", tag: "get banner")
        
        getRequest(url: "home/get_online_course", tag: "get online class")
        
        let userId = readStringPreference(key: DigitalentKeys.ID)
        let parameters: [String:Any] = [
            "id": "\(userId)"
        ]
        postRequest(url: "api/apiprofil", parameters: parameters, tag: "post profile")
        
        loadImageProfile()
    }
    
    @objc func openAccount(_ sender: UITapGestureRecognizer?) {
        let myAccount = MyAccountViewController()
        myAccount.modalPresentationStyle = .fullScreen
        present(myAccount, animated: true, completion: nil)
    }
    
    fileprivate func loadImageProfile(){
        imageProfile.pin_updateWithProgress = true
        imageProfile.contentMode = .scaleToFill
        imageProfile.clipsToBounds = true
        let imageName = readStringPreference(key: DigitalentKeys.USER_PROFILE)
        let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_PROFILE)\(imageName)")!
        
        imageProfile.pin_setImage(from: url)
    }
    
    func registerNib() {
        let nib = UINib(nibName: "HomeBannerCollectionViewCell", bundle: nil)
        bannerCollectionView.register(nib, forCellWithReuseIdentifier: "bannerIdentifier")
        
        let nibClass = UINib(nibName: "OnlineClassCollectionViewCell", bundle: nil)
        onlineClassView.register(nibClass, forCellWithReuseIdentifier: "onlineClassIdentifier")
    }
    
    func setupGridView(){
        let flow = onlineClassView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = 8
        flow.minimumLineSpacing = 16
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        if tag == "get banner" {
            do{
                self.bannerModel = try decoder.decode(BannerModel.self, from:data)
                pageControl.numberOfPages = self.bannerModel.banner.count
                pageControl.currentPage = 0
                
                self.bannerCollectionView.reloadData()
            }catch{
                print(error.localizedDescription)
            }
        }else if tag == "get online class"{
            self.removeSpinner()
            do{
                self.onlineClassModel = try decoder.decode(OnlineClassModel.self, from:data)
                
                itemCount = self.onlineClassModel.online.count
                
                var rowCount: Int = 0
                
                rowCount = itemCount / 2
                
                if itemCount % 2 == 1 {
                    rowCount = itemCount + 1
                }
                
                let widthOnline = self.calculateWidth()
                let heightOnline = widthOnline / 1.2
                let totalRowHeight = heightOnline * CGFloat(rowCount)
                let totalMarginHeight = CGFloat(Double(rowCount-1) * cellMarginSize)
                
                self.onlineClassViewHeight.constant = totalRowHeight + totalMarginHeight
                                
                self.onlineClassView.reloadData()
            }catch{
                print(error.localizedDescription)
            }
        }else if tag == "post profile"{
            do{
                self.homeProfileModel = try decoder.decode(HomeProfileModel.self, from:data)
                
                let firstName = self.homeProfileModel.profil[0].firstName
                
                greetingLabel.text = "Hello \(firstName) !"
            }catch{
                print(error.localizedDescription)
            }
        }else {
            debugPrint("Ini post verify \(data)")
        }
    }
    
    @objc func refreshData(){
        scrollView.refreshControl?.endRefreshing()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            pageControl.currentPage = 0
        }else{
            let scrollPos = (scrollView.contentOffset.x + view.frame.width) / view.frame.width
            pageControl.currentPage = Int(scrollPos)
        }
       
        
        bannerCollectionView.animateVisibleCells()
    }
    
    @IBAction func seeAllClassAction(_ sender: UIButton) {
        let allClass = AllOnlineClassViewController()
        allClass.modalPresentationStyle = .fullScreen
        present(allClass, animated: true, completion: nil)
    }
    
    @IBAction func notifAction(_ sender: UIButton) {
        let notif = NotificationViewController()
        notif.modalPresentationStyle = .fullScreen
        present(notif, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchResult = SearchResultViewController()
        searchResult.modalPresentationStyle = .fullScreen
        searchResult.textSearched = searchBar.text!
        present(searchResult, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return bannerModel?.banner.count ?? 0
            //            return 3
        }else{
            return itemCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerIdentifier", for: indexPath) as! HomeBannerCollectionViewCell
            
            let banner: Banner = bannerModel.banner[indexPath.row]
            
            cell.bannerImage.pin_updateWithProgress = true
            cell.bannerImage.layer.cornerRadius = 15
            cell.bannerImage.contentMode = .scaleToFill
            cell.bannerImage.clipsToBounds = true
            
            let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_BANNER)\(banner.image)")!
            
            cell.bannerImage.pin_setImage(from: url)
            self.bannerCollectionView.animateCell(cell)
            
            return cell
        }else{
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
            cell.baseView.addGestureRecognizer(tap)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionView {
            if let cell = cell as? GeminiCell {
                self.bannerCollectionView.animateCell(cell)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            guard let cell: HomeBannerCollectionViewCell = Bundle.main.loadNibNamed("HomeBannerCollectionViewCell",
                                                                                    owner: self, options: nil)?.first as? HomeBannerCollectionViewCell else {
                return CGSize.zero
            }

            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            let width = collectionView.frame.width - 40
            let height = width / 2.186667
            
            collectionHeight.constant = height
            
            return CGSize(width: width, height: height)
        }else if collectionView == onlineClassView{
            let widthOnline = self.calculateWidth()
            let heightOnline = widthOnline / 1.2
            return CGSize(width: widthOnline, height: heightOnline)
        }else {
            return CGSize(width: 0, height: 0)
        }

    }
    
    func calculateWidth() -> CGFloat{
        let cellCount = CGFloat(2)
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
    @objc func selectCourse(_ sender: ClassDetailTapGesture?) {
        let courseId = sender!.courseId!
       
        let detailClass = OnlineClassDetailViewController()
        detailClass.courseId = courseId
        detailClass.modalPresentationStyle = .fullScreen
        present(detailClass, animated: true, completion: nil)
        
    }
}

