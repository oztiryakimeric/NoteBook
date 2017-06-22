//
//  CommentCell.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 8.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    var comment: Comment?

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ownerLabel: UsernameLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setComment(controller: UIViewController, comment: Comment){
        self.comment = comment
        commentLabel.text = comment.comment
        ownerLabel.start(controller: controller, username: comment.owner)
    }

}
