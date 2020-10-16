//
//  HomeViewController.swift
//  Digitalent
//
//  Created by Teke on 15/10/20.
//

import UIKit
import ImageSlideshow
import PINRemoteImage
import UPCarouselFlowLayout

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var onlineClassView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageBanner: ImageSlideshow!
    
    var bannerModel: BannerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupLayout()
        
        imageProfile.makeRoundedWithBorder()
        
        onlineClassView.delegate = self
        onlineClassView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerNib()
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        getRequest(url: "home/get_home_banner", tag: "get banner")
        
        //        let parameters: [String:Any] = [
        //            "uid": "5853"
        //        ]
        //        postRequest(url: "api/verify_progress", parameters: parameters, tag: "post verify")
        
        let height = CGFloat(Float(20) * Float(125))
        tableViewHeight.constant = height
        
        onlineClassView.reloadData()
    }
    
    func registerNib() {
        let nib = UINib(nibName: "HomeBannerCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "bannerIdentifier")
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        if tag == "get banner" {
            do{
                self.bannerModel = try decoder.decode(BannerModel.self, from:data)
                pageControl.numberOfPages = self.bannerModel.banner.count
                pageControl.currentPage = 0
                collectionHeight.constant = collectionView.contentSize.height
                
                self.collectionView.reloadData()
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
    
    func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = (scrollView.contentOffset.x + 90) / view.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerModel?.banner.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerIdentifier", for: indexPath) as! HomeBannerCollectionViewCell
        
        let banner: Banner = bannerModel.banner[indexPath.row]
        
        cell.bannerImage.pin_updateWithProgress = true
        cell.bannerImage.layer.cornerRadius = 15
        cell.bannerImage.contentMode = .scaleToFill
        cell.bannerImage.clipsToBounds = true
        
        let url = Foundation.URL(string: "\(DigitalentURL.URL_IMAGE_BANNER)\(banner.image)")!
        
        cell.bannerImage.pin_setImage(from: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: HomeBannerCollectionViewCell = Bundle.main.loadNibNamed("HomeBannerCollectionViewCell",
                                                                                owner: self, options: nil)?.first as? HomeBannerCollectionViewCell else {
            return CGSize.zero
        }
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
//        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: collectionView.frame.width - 20, height: 150)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

