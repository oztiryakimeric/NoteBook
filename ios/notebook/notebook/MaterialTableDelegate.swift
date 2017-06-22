//
//  MaterialListDelegate.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 5.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class MaterialTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    let controller: UIViewController
    let dataSource: MaterialListDataSource
    
    init(controller: UIViewController, dataSource: MaterialListDataSource) {
        self.controller = controller
        self.dataSource = dataSource
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(107.5)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.materialList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        controller.performSegue(withIdentifier: "open_material_screen", sender: indexPath);
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MaterialCell", owner: self, options: nil)?.first as! MaterialCell
        let material = dataSource.giveMaterial(indexPath: indexPath)
        
        cell.setMaterial(controller: controller, material: material)
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height + 200 > scrollView.contentSize.height{
            if(!dataSource.isLoading){
                dataSource.getNextPage()
            }
        }
    }
}
