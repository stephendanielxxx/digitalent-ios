//
//  NotificationViewController.swift
//  Digitalent
//
//  Created by Teke on 20/10/20.
//

import UIKit

class NotificationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var notificationModel: NotificationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getRequest(url: "home/get_notif", tag: "get all notif")
        
        let nibClass = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        tableView.register(nibClass, forCellReuseIdentifier: "notifIdentifier")
        
    }
    
    override func onSuccess(data: Data, tag: String) {
        do{
            let decoder = JSONDecoder()
            self.notificationModel = try decoder.decode(NotificationModel.self, from:data)
            
            if self.notificationModel.notif.count > 0{
                emptyView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }else{
                emptyView.isHidden = false
                self.tableView.isHidden = true
            }
        }catch{
            print(error.localizedDescription)
        }
    }

    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationModel?.notif.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifIdentifier") as! NotificationTableViewCell
        
        let taskModel: NotifModel = (notificationModel?.notif[indexPath.row])!
        
        cell.titleLabel.text = taskModel.notifName
        cell.contentTextView.attributedText = taskModel.notifDescription.htmlToAttributedString
        
        return cell
    }
}
