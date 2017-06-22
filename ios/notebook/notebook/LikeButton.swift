//
//  LikeButton.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 6.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

@IBDesignable class LikeButton: UIView, LikeDataDelegate{
    var contentView : UIView!
    
    var material: Material?
    var dataSource: LikeDataSource?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var isLiked: Bool = false
    
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
    
    func setMaterial(material: Material){
        self.material = material
        self.dataSource = LikeDataSource(material: material, user: User(id: 1, username: "asdf", password: "", email: "", first_name: "", second_name: ""))
        self.dataSource?.delegate = self
        setLikeCount()
        isLiked = material.liked
        if material.liked {
            image.image = UIImage(named: "like_red.png")
        }
        else{
            image.image = UIImage(named: "like.png")
        }
    }
    
    func onSuccess() {
        print("Like source success")
        if isLiked{
            material!.favoriteCount! += 1
        }else{
            material!.favoriteCount! -= 1
        }
        setLikeCount()
    }
    
    func onFailure() {
        print("Like source fail")
        if isLiked{
            unlike()
        }else{
            like()
        }
    }
    
    func like(){
        animateTo(image: "like_red.png")
        isLiked = true
    }
    
    func unlike(){
        animateTo(image: "like.png")
        isLiked = false
    }
    
    private func animateTo(image: String){
        UIView.animate(withDuration: 0.1, animations: {
            self.minimizeImage()
        }) { (success) in
            UIView.animate(withDuration: 0.1) {
                self.maximazeImage()
                self.image.image = UIImage(named: image)
            }
        }
    }
    
    private func minimizeImage(){
        image.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
    }
    
    private func maximazeImage(){
        image.transform = CGAffineTransform.identity
    }
    
    private func setLikeCount(){
        label.text = "\(material!.favoriteCount!)"
    }
    
    @IBAction func onClicked(_ sender: Any) {
        if isLiked{
            unlike()
            dataSource?.unlike()
        }
        else{
            like()
            dataSource?.like()
        }
    }
}
