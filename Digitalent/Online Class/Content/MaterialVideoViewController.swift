//
//  MaterialVideoViewController.swift
//  Digitalent
//
//  Created by Teke on 05/11/20.
//

import UIKit
import ASPVideoPlayer
import AVFoundation

class MaterialVideoViewController: UIViewController {

    var video = ""
    
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
