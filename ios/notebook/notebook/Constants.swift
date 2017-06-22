//
//  Constants.swift
//  notebook
//
//  Created by Meriç Öztiryaki on 26.04.2017.
//  Copyright © 2017 Meriç Öztiryaki. All rights reserved.
//

import Foundation
import UIKit

let pageSize = 10

struct Api{
    static let loginUrl = "https://cs392-project.herokuapp.com/login/"
    static let signupUrl = "https://cs392-project.herokuapp.com/user/"
    static let classListUrl = "https://cs392-project.herokuapp.com/department/"
    static let materialUrl = "https://cs392-project.herokuapp.com/material/"
    static let commentUrl = "https://cs392-project.herokuapp.com/comment/"
    static let feedbackUrl = "https://cs392-project.herokuapp.com/feedback/"
    static let favoriteUrl = "https://cs392-project.herokuapp.com/favorite/"
}

struct Color{
    static let blue: UIColor = UIColor(colorLiteralRed: 51/255, green: 98/255, blue: 233/255, alpha: 1)
    static let green: UIColor = UIColor(colorLiteralRed: 38/255, green: 177/255, blue: 128/255, alpha: 1)
    static let orange: UIColor = UIColor(colorLiteralRed: 255/255, green: 150/255, blue: 115/255, alpha: 1)
}
