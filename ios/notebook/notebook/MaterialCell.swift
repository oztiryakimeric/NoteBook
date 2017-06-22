//
//  MaterialCellV2.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 6.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class MaterialCell: UITableViewCell, CommentDataDelegate {
    var controller: UIViewController?
    var material: Material?
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var usernameLabel: UsernameLabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: LikeButton!
    @IBOutlet weak var commentButton: CommentButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setMaterial(controller: UIViewController, material: Material){
        self.controller = controller
        self.material = material
        initializeViews()
    }
    
    private func initializeViews(){
        headerLabel.text = material!.header
        usernameLabel.start(controller: controller!, username: material!.ownerUser)
        descriptionLabel.text = material!.description
        likeButton.setMaterial(material: material!)
        commentButton.setMaterial(delegate: self, material: material!)
        feedbackLabel.text = String(format: "%.1f", ceil(material!.feedback!*100)/100)
    }
    
    func commentPosted() {
        material!.commentCount! = material!.commentCount! + 1
        commentButton.setCommentCount()
    }
}
