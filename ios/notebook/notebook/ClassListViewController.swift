//
//  FirstViewController.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 15.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class ClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassListDataDelegate, CustomDialogDelegate, MaterialDataDelegate{

    @IBOutlet weak var classListTableView: UITableView!
    
    let dataSource = ClassListDataSource()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.dataDelegate = self
        
        
        navigationController?.navigationBar.barTintColor = Color.green
        UINavigationBar.appearance().tintColor = UIColor.black
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(ClassListViewController.refresh), for: UIControlEvents.valueChanged)
        classListTableView.addSubview(refreshControl)
        
        dataSource.getInitialDepartmentList()
    }
    
    @objc func refresh() {
        dataSource.reloadData()
    }
    
    func onDataUpdate() {
        classListTableView.reloadData()
        UIView.animate(withDuration: 0.3) { 
            self.classListTableView.alpha = 1
        }
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        classListTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.departmentList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.departmentList[section].classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "class_view_cell", for: indexPath) as! ClassCell
        
        let code = dataSource.giveClass(indexPath: indexPath).classCode
        let name = dataSource.giveClass(indexPath: indexPath).className
        let materialCount = dataSource.giveDepartment(indexPath: indexPath).classList[indexPath.row].materialCount
        
        cell.classCodeAndName.text = "\(code) - \(name)"
        cell.materialCount.text = "\(materialCount) Materials"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.departmentList[section].departmentName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(44)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("ClassHeader", owner: self, options: nil)?.first as! ClassHeader
        
        let department = dataSource.giveDepartment(index: section)
        headerView.departmentLabel.text = "\(department.departmentCode) | \(department.departmentName)";
        
        return headerView.contentView;
    }
    
    var isDialogShown: Bool = false
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addNewMaterial = UITableViewRowAction(style: .normal, title: "Add") { (action, indexPath) in
            if !self.isDialogShown{
                let dialog = MaterialDialog.create(controller: self, classId: self.dataSource.giveClass(indexPath: indexPath).id)
                dialog.delegate = self
                dialog.show()
                self.isDialogShown = true
            }
        }
        addNewMaterial.backgroundColor = Color.blue
        
        return [addNewMaterial]
    }
    
    func onDialogClose() {
        print("dialog closed")
        isDialogShown = false
    }
    
    func onMaterialPost() {
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.size.height + 200 > scrollView.contentSize.height{
            if(!dataSource.isLoading){
                dataSource.getNextPage()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCell = sender as! ClassCell
        
        let indexPath = self.classListTableView.indexPath(for: selectedCell)
        
        let controller = segue.destination as! MaterialListViewController
        
        controller._class = dataSource.giveClass(indexPath: indexPath!)
    }
}






