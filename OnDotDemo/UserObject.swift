//
//  UserObject.swift
//  OnDotDemo
//
//  Created by Hiren Bhadreshwara on 25/10/17.
//  Copyright © 2017 Hiren Bhadreshwara. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserObject {
    var pictureURL: String!
    var username: String!
    
    required init(json: JSON) {
        pictureURL = json["picture"]["medium"].stringValue
        username = json["email"].stringValue
    }
}
