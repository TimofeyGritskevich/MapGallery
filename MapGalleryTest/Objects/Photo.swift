//
//  Photo.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class Photo: Object {
    @objc dynamic var date: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    @objc dynamic var imageStr: String = ""

    convenience init(date: Int, id: Int, lat: Double, lng: Double, imageStr: String) {
        self.init()
        self.date = date
        self.id = id
        self.lat = lat
        self.lng = lng
        self.imageStr = imageStr
    }
}
