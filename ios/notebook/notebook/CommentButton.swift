//
//  CommentButton.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 6.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

@IBDesignable class CommentButton: UIView {
    var contentView : UIView!
    
    var delegate: CommentDataDelegate?
    var material: Material?
    
    @IBOutlet weak var label: UILabel!
    
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
    
    func setMaterial(delegate: CommentDataDelegate, material: Material){
        self.delegate = delegate
        self.material = material
        setCommentCount()
    }
    
    func setCommentCount(){
        label.text = "\(material!.commentCount!)"
    }
    
    @IBAction func onClicked(_ sender: Any) {
        let comment = CommentDialog.create(dataDelegate: delegate! , material: material!)
        comment.show()
    }
}
