//
//  Material.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 30.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Wrap
import Unbox

class Material: Unboxable{
    var id: Int?
    let ownerClass: Int
    let ownerUser: String
    var favoriteCount: Int?
    var liked: Bool = false
    var commentCount: Int?
    let header: String
    let description: String
    let fileUrl: String
    var feedback: Double?
    
    required init(unboxer: Unboxer) throws {
        self.id = unboxer.unbox(key: "id")
        self.ownerClass = try unboxer.unbox(key: "_class")
        self.ownerUser = try unboxer.unbox(key: "owner")
        self.favoriteCount = unboxer.unbox(key: "favorite_count")
        self.liked = try unboxer.unbox(key: "liked")
        self.commentCount = unboxer.unbox(key: "comment_count")
        self.header = try unboxer.unbox(key: "header")
        self.description = try unboxer.unbox(key: "description")
        self.fileUrl = try unboxer.unbox(key: "file_url")
        self.feedback = unboxer.unbox(key: "feedback")
        if favoriteCount == -1{
            favoriteCount = 3
        }
    }
    
    init(ownerClass: Int, ownerUser: String,header: String, description: String, fileUrl: String) {
        self.ownerClass = ownerClass
        self.ownerUser = ownerUser
        self.header = header
        self.description = description
        self.fileUrl = fileUrl
    }
    
    func toJson() -> [String: Any]?{
        return ["description": description, "owner": ownerUser, "file_url": fileUrl, "header": header, "_class": ownerClass]
    }
}
