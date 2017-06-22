//
//  ClassCell.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 26.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {
    
    @IBOutlet weak var classCodeAndName: UILabel!
    @IBOutlet weak var materialCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
