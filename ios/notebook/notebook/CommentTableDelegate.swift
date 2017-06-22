//
//  CommentTableDelegate.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 12.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class CommentTableDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    let controller: UIViewController
    let dataSource: CommentDataSource
    
    init(controller: UIViewController, dataSource: CommentDataSource){
        self.dataSource = dataSource
        self.controller = controller
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.commentList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CommentCell", owner: self, options: nil)?.first as! CommentCell
        let commentObj = dataSource.giveComment(indexPath: indexPath)
        
        cell.setComment(controller: controller, comment: commentObj)
        
        return cell
    }
}
