//
//  HeaderView.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 2.05.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import UIKit

class HeaderView{
    let material: Material
    var scrollView: UIScrollView
    var view: UIView
    var stack: UIStackView
    var headerLabel: UILabel
    var usernameLabel: UILabel
    
    var heightConstraint: NSLayoutConstraint
    var topSpaceConstraint: NSLayoutConstraint
    
    var isHeaderShrinked: Bool = false
    var lastPosition: CGFloat = 0
    
    init(material: Material, scrollView: UIScrollView, view: UIView, stack: UIStackView, headerLabel: UILabel, usernameLabel: UILabel, heightConstraint: NSLayoutConstraint, topSpaceConstraint: NSLayoutConstraint) {
        self.material = material
        self.scrollView = scrollView
        self.view = view
        self.stack = stack
        self.headerLabel = headerLabel
        self.usernameLabel = usernameLabel
        self.heightConstraint = heightConstraint
        self.topSpaceConstraint = topSpaceConstraint
        self.view.backgroundColor = Color.orange
    }
    
    
}
