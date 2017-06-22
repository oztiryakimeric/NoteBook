//
//  Department.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 25.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Wrap
import Unbox

class Department: Equatable, Unboxable{
    let id: Int
    let faculty: String
    let departmentName: String
    let departmentCode: String
    let classList: [Class]
    
    required init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.faculty = try unboxer.unbox(key: "faculty")
        self.departmentName = try unboxer.unbox(key: "department_name")
        self.departmentCode = try unboxer.unbox(key: "department_code")
        self.classList = try unboxer.unbox(key: "classes")
    }
    
    init(id: Int, faculty: String, departmentName: String, departmentCode: String, classList:[Class]){
        self.id = id
        self.faculty = faculty
        self.departmentName = departmentName
        self.departmentCode = departmentCode
        self.classList = classList
    }
    
    func toJson() -> [String: Any]?{
        do{
            return try wrap(self)
        }catch{
            print("Error on wraping department")
        }
        return nil
    }
    
    public static func ==(lhs: Department, rhs: Department) -> Bool{
        return lhs.id == rhs.id &&
            lhs.faculty == rhs.faculty &&
            lhs.departmentName == rhs.departmentName &&
            lhs.departmentCode == rhs.departmentCode &&
            lhs.classList == rhs.classList
    }
}
