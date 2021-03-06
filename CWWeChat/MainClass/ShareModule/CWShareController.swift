//
//  CWShareController.swift
//  CWWeChat
//
//  Created by wei chen on 2017/3/30.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import UIKit
import SwiftyJSON

class CWShareController: CWBaseTableViewController {

    var shareLayouts = [CWShareLayout]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "分享"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(CWShareCell.self, forCellReuseIdentifier: CWShareCell.identifier)
        setupUI()
    }
    
    func setupUI() {
        
        
        guard let path = Bundle.main.path(forResource: "shares", ofType: "json"),
            let shareData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        
        guard let shareList = JSON(data: shareData).dictionary?["data"]?.array else {
            return
        }
        
        for share in shareList {
            let shareId = share["share"].stringValue
            let username = share["username"].stringValue
            let userId = share["userId"].stringValue
            let date = share["date"].doubleValue

            let content = share["content"].string
            let share_Date = Date(timeIntervalSince1970: date/1000)
            let shareModel = CWShareModel(shareId: shareId,
                                     username: username,
                                     userId: userId,
                                     date: share_Date)
            shareModel.content = content
            
            let items = share["images"].arrayValue
            for item in items {
                let url1 = URL(string: item["largetURL"].stringValue)!
                let url2 = URL(string: item["thumbnailURL"].stringValue)!

                let imageModel = CWSharePictureModel(thumbnailURL: url2, largetURL: url1)
                shareModel.imageArray.append(imageModel)
            }
            
            let layout = CWShareLayout(shareModel: shareModel)
            shareLayouts.append(layout)
            
        }
        

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CWShareController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareLayouts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return shareLayouts[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CWShareCell.identifier, for: indexPath) as! CWShareCell
        cell.delegate = self
        cell.setLayout(shareLayouts[indexPath.row])
        return cell
    }
    
    
}


extension CWShareController: CWShareCellDelegate {
    func shareCell(_ cell: CWShareCell, didClickImageAtIndex index: Int) {
        log.debug("选择---\(index)")
    }
    
    func shareCell(_ cell: CWShareCell, didClickInText text: NSAttributedString, textRange: NSRange) {
        
    }
}
