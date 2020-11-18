//
//  MaterialVideoViewController.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit
import ASPVideoPlayer
import AVFoundation

class MaterialVideoViewController: BaseViewController {

    var video = ""
    var course_id = ""
    var sub_material_id = ""
    
    var controls: ASPVideoPlayerControls!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoPlayerBackgroundView: UIView!
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoUrl = "\(DigitalentURL.URL_VIDEO_CLASS)\(video)"
        let secondNetworkURL = URL(string: videoUrl)
        let secondAsset = AVURLAsset(url: secondNetworkURL!)
        videoPlayer.backgroundColor = UIColor.white
        
        videoPlayer.videoAssets = [secondAsset]
        videoPlayer.videoPlayerControls.tintColor = UIColor(named: "red_1")
        
        videoPlayer.resizeClosure = { [unowned self] isExpanded in
            self.rotate(isExpanded: isExpanded)
        }
        
        controls = videoPlayer.videoPlayerControls as? ASPVideoPlayerControls
        
        let userId = readStringPreference(key: DigitalentKeys.ID)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let currentDate = dateFormatterGet.string(from: date)
        
        let params:[String: Any] = [
            "user_id":"\(userId)",
            "sub_material_id":"\(sub_material_id)",
            "course_id":"\(course_id)",
            "start_at":"\(currentDate)",
            "end_at":"\(currentDate)",
            "status":"1"
        ]
        
        postRequest(url: "quiz/submit_vid", parameters: params, tag: "post submit video")
    }
    
    override func onSuccess(data: Data, tag: String) {
        let decoder = JSONDecoder()
        do {
            let submitModel = try decoder.decode(SubmitProgressModel.self, from: data)
            print(submitModel.status)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        controls?.stop()
    }
    
    var previousConstraints: [NSLayoutConstraint] = []
    
    func rotate(isExpanded: Bool) {
        let views: [String:Any] = ["videoPlayer": videoPlayer as Any,
                                   "backgroundView": videoPlayerBackgroundView as Any]
        
        var constraints: [NSLayoutConstraint] = []
        
        if isExpanded == false {
            self.containerView.removeConstraints(self.videoPlayer.constraints)
            
            self.view.addSubview(self.videoPlayerBackgroundView)
            self.view.addSubview(self.videoPlayer)
            self.videoPlayer.frame = self.containerView.frame
            self.videoPlayerBackgroundView.frame = self.containerView.frame
            
            let padding = (self.view.bounds.height - self.view.bounds.width) / 2.0
            
            var bottomPadding: CGFloat = 0
            
            if #available(iOS 11.0, *) {
                if self.view.safeAreaInsets != .zero {
                    bottomPadding = self.view.safeAreaInsets.bottom
                }
            }
            
            let metrics: [String:Any] = ["padding":padding,
                                         "negativePaddingAdjusted":-(padding - bottomPadding),
                                         "negativePadding":-padding]
            
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePaddingAdjusted)-[videoPlayer]-(negativePaddingAdjusted)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: views))
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[videoPlayer]-(padding)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: views))
            
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(negativePadding)-[backgroundView]-(negativePadding)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: views))
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[backgroundView]-(padding)-|",
                                               options: [],
                                               metrics: metrics,
                                               views: views))
            
            self.view.addConstraints(constraints)
        } else {
            self.view.removeConstraints(self.previousConstraints)
            
            let targetVideoPlayerFrame = self.view.convert(self.videoPlayer.frame, to: self.containerView)
            let targetVideoPlayerBackgroundViewFrame = self.view.convert(self.videoPlayerBackgroundView.frame, to: self.containerView)
            
            self.containerView.addSubview(self.videoPlayerBackgroundView)
            self.containerView.addSubview(self.videoPlayer)
            
            self.videoPlayer.frame = targetVideoPlayerFrame
            self.videoPlayerBackgroundView.frame = targetVideoPlayerBackgroundViewFrame
            
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[videoPlayer]|",
                                               options: [],
                                               metrics: nil,
                                               views: views))
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[videoPlayer]|",
                                               options: [],
                                               metrics: nil,
                                               views: views))
            
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundView]|",
                                               options: [],
                                               metrics: nil,
                                               views: views))
            constraints.append(contentsOf:
                NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundView]|",
                                               options: [],
                                               metrics: nil,
                                               views: views))
            
            self.containerView.addConstraints(constraints)
        }
        
        self.previousConstraints = constraints
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            self.videoPlayer.transform = isExpanded == true ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
            self.videoPlayerBackgroundView.transform = isExpanded == true ? .identity : CGAffineTransform(rotationAngle: .pi / 2.0)
            
            self.view.layoutIfNeeded()
        })
    }
}
