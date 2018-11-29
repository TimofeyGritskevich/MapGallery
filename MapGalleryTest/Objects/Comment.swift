//
//  Comment.swift
//  MapGalleryTest
//
//  Created by Tima on 27.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Comment: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var imageId: Int = 0

    convenience init(title: String, date: Int, id: Int, imageId: Int) {
        self.init()
        self.title = title
        self.date = date
        self.id = id
        self.imageId = imageId
    }
}
