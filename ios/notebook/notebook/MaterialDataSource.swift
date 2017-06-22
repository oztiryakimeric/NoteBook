//
//  MaterialDataSource.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 2.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

@objc protocol MaterialDataDelegate{
    @objc optional func onFeedbackUpdate(to: Double)
    func onMaterialPost()
}

class MaterialDataSource{
    let material: Material
    
    var dataDelegate: MaterialDataDelegate?
    
    init(material: Material) {
        self.material = material
    }
    
    func sendFeedback(point: Int){
        print("Feedback sending...")
        
        let parameters = ["material": "\(material.id!)", "point": "\(point)"]
        Alamofire.request(Api.feedbackUrl, method: .post, parameters: parameters).responseJSON() {
            (response) in
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                self.dataDelegate!.onFeedbackUpdate!(to: JSON["average"] as! Double)
            }
        }
    }
    
    func postMaterial(){
        Alamofire.request(Api.materialUrl, method: .post, parameters: material.toJson()).responseJSON() {
            (response) in
            self.dataDelegate!.onMaterialPost()
        }
    }
}
