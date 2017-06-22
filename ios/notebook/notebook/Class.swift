//
//  Class.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 25.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Wrap
import Unbox

class Class: Equatable, Unboxable{
    let id: Int
    let department: String
    let className: String
    let classCode: String
    let materialCount: Int
    
    
    required init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.department = try unboxer.unbox(key: "department")
        self.className = try unboxer.unbox(key: "class_name")
        self.classCode = try unboxer.unbox(key: "class_code")
        self.materialCount = try unboxer.unbox(key: "material_count")
    }
    
    init(id: Int, department: String, className: String, classCode: String, materialCount:Int) {
        self.id = id
        self.department = department
        self.className = className
        self.classCode = classCode
        self.materialCount = materialCount
    }
    
    func toJson() -> [String: Any]?{
        do{
            return try wrap(self)
        }catch{
            print("Error on wraping department")
        }
        return nil
    }
    
    public static func ==(lhs: Class, rhs: Class) -> Bool{
        return lhs.id == rhs.id &&
        lhs.department == rhs.department &&
        lhs.className == rhs.className &&
        lhs.classCode == rhs.classCode &&
        lhs.materialCount == rhs.materialCount
    }
}
