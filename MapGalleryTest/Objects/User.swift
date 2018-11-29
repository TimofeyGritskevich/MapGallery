//
//  User.swift
//  MapGalleryTest
//
//  Created by Tima on 28.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    var name: String?
    var id: Int?
    var token: String?
    
    init(json: JSON) {      
        self.name = json["data"]["login"].stringValue
        self.id = json["data"]["userId"].intValue
        self.token = json["data"]["token"].stringValue
    }
}
