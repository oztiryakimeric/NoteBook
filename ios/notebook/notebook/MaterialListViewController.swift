//
//  MaterialListViewController.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 30.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class MaterialListViewController: UIViewController, MaterialListDataDelegate, CustomDialogDelegate, MaterialDataDelegate{

    var _class: Class?
    var dataSource: MaterialListDataSource?
    var tableDelegate: MaterialTableDelegate?
    
    var isDialogShown: Bool = false
    
    @IBOutlet weak var materialListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = _class?.className
        
        dataSource = MaterialListDataSource.belongToClass(_class: _class!, currentUser: AuthHelper.getCurrentUser()!, delegate: self)
        dataSource?.getInitialMaterialList()
        
        tableDelegate = MaterialTableDelegate(controller: self, dataSource: dataSource!)
        materialListTableView.dataSource = tableDelegate
        materialListTableView.delegate = tableDelegate
        
        addNewMaterialButton()
    }
    
    
    
    func onDataUpdate() {
        materialListTableView.reloadData()
    }
    
    @objc func onAddMaterialButtonClicked() {
        if !isDialogShown{
            let dialog = MaterialDialog.create(controller: self, classId: _class!.id)
            dialog.show()
            isDialogShown = true
        }
    }
    
    func onDialogClose() {
        isDialogShown = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        materialListTableView.deselectRow(at: sender as! IndexPath, animated: true)
        if (segue.identifier == "open_material_screen") {
            let controller = segue.destination as! MaterialViewController
            let indexPath = sender as! IndexPath
            
            controller.material = dataSource?.giveMaterial(indexPath: indexPath)
            //controller._class = _class!
            controller.title = _class!.className
        }
        
        if (segue.identifier == "open_profile_screen") {
            let navigation = segue.destination as! UINavigationController
            let controller = navigation.viewControllers.first as! ProfileViewController
            
            let user = sender as! User
            
            controller.user = user
        }
    }
    
    private func addNewMaterialButton(){
        let addMaterialButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MaterialListViewController.onAddMaterialButtonClicked))
        self.navigationItem.setRightBarButtonItems([addMaterialButton], animated: false)
    }
    
    func onMaterialPost() {
        dataSource?.reloadData()
    }
}
