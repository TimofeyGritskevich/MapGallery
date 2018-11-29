//
//  RealmManager.swift
//  MapGalleryTest
//
//  Created by Tima on 27.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RealmManager: NSObject {
    
    static let realm = try! Realm()
    static var photoResult: Results<Photo> {
        get {
            return realm.objects(Photo.self)
        }
    }
    
    static var commentResult: Results<Comment> {
        get {
            return realm.objects(Comment.self)
        }
    }
    
    static func savePhotToRealm (photo: Photo) {
        try! realm.write {
            realm.add(photo)
        }
    }
    
    static func saveCommentToRealm (comment: Comment) {
        try! realm.write {
            realm.add(comment)
        }
    }
    
    static func deletePhotoFromRealm (photo: Photo) {
        let comments = realm.objects(Comment.self).filter("id = %d", photo.id)
        try! realm.write {
            realm.delete(comments)
        }
        try! realm.write {
            realm.delete(photo)
        }
    }
    
    static func deleteCommentFromRealm(comment: Comment) {
        try! realm.write {
            realm.delete(comment)
        }
    } 
}
