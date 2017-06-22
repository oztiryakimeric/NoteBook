//
//  DepartmentHelper.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 25.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

@objc protocol ClassListDataDelegate{
    @objc optional func onDataUpdate();
}

class ClassListDataSource: NSObject{
    var dataDelegate: ClassListDataDelegate?
    
    var departmentList: [Department] = []
    var currentPage = 2
    var isLoading: Bool = false
    
    func getInitialDepartmentList(){
        getDepartmentsAtPage(page: 1)
        dataDelegate?.onDataUpdate!()
    }
    
    func reloadData(){
        departmentList.removeAll()
        dataDelegate?.onDataUpdate!()
        getDepartmentsAtPage(page: 1)
        dataDelegate?.onDataUpdate!()
    }
    
    func getNextPage(){
        let oldCount = departmentList.count
        getDepartmentsAtPage(page: currentPage)
        if(oldCount != departmentList.count){
            currentPage += 1   
        }
        dataDelegate?.onDataUpdate!()
    }
    
    private func getDepartmentsAtPage(page: Int){
        print("Department list request send for page: \(page)")
        isLoading = true
        Alamofire.request(Api.classListUrl, method: .get, parameters: ["page": page]).responseJSON() {
            (response) in
            do{
                self.departmentList.append(contentsOf: try unbox(data:response.data!))
                self.dataDelegate?.onDataUpdate!()
                self.isLoading = false
            }catch{
                print("Error while downloading")
            }
        }
    }
    
    func giveDepartment(indexPath: IndexPath) -> Department{
        return departmentList[indexPath.section]
    }
    
    func giveDepartment(index: Int) -> Department{
        return departmentList[index]
    }
    
    func giveClass(indexPath: IndexPath) -> Class{
        return departmentList[indexPath.section].classList[indexPath.row]
    }
}
