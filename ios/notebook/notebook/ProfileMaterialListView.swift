//
//  ProfileMaterialListView.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 14.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

@IBDesignable class ProfileMaterialListView: UIView, UIScrollViewDelegate {
    var contentView : UIView!
    
    var parent: UIViewController?
    var user: User?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var container: UIView!
    
    var sharedMaterialTable: UITableView?
    var favoritedMaterialTable: UITableView?
    
    var sharedTableDataSource: MaterialListDataSource?
    var favoritedTableDataSource: MaterialListDataSource?
    
    var sharedTableDelegate: MaterialTableDelegate?
    var favoritedTableDelegate: MaterialTableDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        contentView.frame = bounds
        
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(contentView)
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
    func start(parent: UIViewController, user: User){
        self.parent = parent
        self.user = user
        
        createSharedMaterialTable()
        createFavoritedMaterialTable()
        //showFirstTable()
    }
    
    private func createSharedMaterialTable(){
        sharedMaterialTable = UITableView(frame: CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height))
        sharedMaterialTable!.separatorStyle = .none
        //sharedMaterialTable?.alpha = 0
        sharedMaterialTable!.backgroundColor = container.backgroundColor
        
        sharedTableDataSource = MaterialListDataSource.sharedByUser(user: user!, delegate: parent as! MaterialListDataDelegate)
        sharedTableDelegate = MaterialTableDelegate(controller: parent!, dataSource: sharedTableDataSource!)
        
        sharedMaterialTable!.delegate = sharedTableDelegate!
        sharedMaterialTable!.dataSource = sharedTableDelegate!
        
        sharedTableDataSource?.getInitialMaterialList()
    }
    
    private func addTables(){
        container.addSubview(sharedMaterialTable!)
        container.addSubview(favoritedMaterialTable!)
    }
    
    private func showFirstTable(){
        sharedMaterialTable?.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        sharedMaterialTable?.alpha = 1
        favoritedMaterialTable?.frame = CGRect(x: container.frame.width, y: 0, width: container.frame.width, height: container.frame.height)
        favoritedMaterialTable?.alpha = 0
    }
    
    private func showSecondTable(){
        sharedMaterialTable?.frame = CGRect(x: -container.frame.width, y: 0, width: container.frame.width, height: container.frame.height)
        sharedMaterialTable?.alpha = 0
        favoritedMaterialTable?.frame = CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        favoritedMaterialTable?.alpha = 1
    }
    
    private func createFavoritedMaterialTable(){
        favoritedMaterialTable = UITableView(frame: CGRect(x: container.frame.width, y: 0, width: container.frame.width, height: container.frame.height))
        favoritedMaterialTable!.separatorStyle = .none
        favoritedMaterialTable!.backgroundColor = container.backgroundColor
        //favoritedMaterialTable?.alpha = 0
        
        favoritedTableDataSource = MaterialListDataSource.favoritedByUser(user: user!, delegate: parent  as! MaterialListDataDelegate)
        favoritedTableDelegate = MaterialTableDelegate(controller: parent!, dataSource: favoritedTableDataSource!)
        
        favoritedMaterialTable!.delegate = favoritedTableDelegate
        favoritedMaterialTable!.dataSource = favoritedTableDelegate
        
        favoritedTableDataSource?.getInitialMaterialList()
        favoritedMaterialTable?.allowsSelection = false
    }
    
    var tablesShown: Bool = false
    func reloadData(){
        if !tablesShown{
            addTables()
            tablesShown = true
        }
        sharedMaterialTable!.reloadData()
        favoritedMaterialTable!.reloadData()
    }
    
    func giveSelectedMaterial() -> Material{
        return sharedTableDataSource!.giveMaterial(indexPath: sharedMaterialTable!.indexPathForSelectedRow!)
    }
    
    @IBAction func onSegmentedControlValueChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.showFirstTable()
            }, completion: nil)
            
        case 1:
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
                self.showSecondTable()
            }, completion: nil)
            
        default:
            break
        }
    }
    
}
