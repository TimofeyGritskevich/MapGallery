//
//  Manager.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class Manager: NSObject {

    static var userDefaults = UserDefaults.standard
    static var longitude = 0.0
    static var latitude = 0.0
    static var user: User?

    static func setTimeFromUnix(unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func setImageFromString(str: String) -> UIImage {
        let encodedImageData = str
        let imageData = Data(base64Encoded: encodedImageData, options: .ignoreUnknownCharacters)
        return UIImage(data: imageData!)!
    }
    
    static func saveUserName(date: String) {
        userDefaults.set(date, forKey: "UserName")
        userDefaults.synchronize()
    }
    
    static func loadUserName() -> String {
        return userDefaults.object(forKey: "UserName") as? String ?? ""
    }
    
    static func savePassword(date: String) {
        userDefaults.set(date, forKey: "UserPassword")
        userDefaults.synchronize()
    }
    
    static func loadPassword() -> String {
        return userDefaults.object(forKey: "UserPassword") as? String ?? ""
    }
    
}
