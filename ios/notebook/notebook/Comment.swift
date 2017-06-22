//
//  Comment.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 2.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Unbox

class Comment: Unboxable{
    var id: Int?
    let material: Int
    let owner: String
    let comment: String
    var postDate: String?
    
    required init(unboxer: Unboxer) throws {
        self.id = unboxer.unbox(key: "id")
        self.material = try unboxer.unbox(key: "material")
        self.owner = try unboxer.unbox(key: "owner")
        self.comment = try unboxer.unbox(key: "comment")
        self.postDate = unboxer.unbox(key: "postDate")
    }
    
    init(material: Int, owner: String, comment: String) {
        self.material = material
        self.owner = owner
        self.comment = comment
    }
}
