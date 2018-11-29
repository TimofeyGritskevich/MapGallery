//
//  NetworkManager.swift
//  MapGalleryTest
//
//  Created by Tima on 28.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager: NSObject {

    static func registerUser(login: String, password: String, completion: @escaping (_ user: User?, _ error: JSON?) -> ()) {
        
        let parameters: Parameters = ["login": login,
                                      "password": password]
        request("http://junior.balinasoft.com/api/account/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
             if json["status"] == 200 {
                completion(User(json: json), nil)
            } else {
                completion(nil, json)
            }
        }
    }
    
    static func loginUser(login: String, password: String, completion: @escaping (_ user: User?, _ error: JSON?) -> ()) {

        let parameters: Parameters = ["login": login,
                                      "password": password]
        request("http://junior.balinasoft.com/api/account/signin", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
            if json["status"] == 200 {
                completion(User(json: json), nil)
            } else {
                completion(nil, json)
            }
        }
    }
    
    static func postPhotToServer (imageString: String, completion: @escaping (_ photo: JSON) -> ()) {
        let parameters: Parameters = ["base64Image": imageString,
                          "date": Int(Date().timeIntervalSince1970),
                          "lat": Manager.latitude,
                          "lng": Manager.longitude]
        let headers: HTTPHeaders = ["Access-Token": (Manager.user?.token)!]
        request("http://junior.balinasoft.com/api/image", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
            completion(json)
        }
    }
    
    static func getPhotoFromServer(page: Int) {
        let parameters: Parameters = ["page" : page]
        let headers: HTTPHeaders = ["Access-Token": (Manager.user?.token)!]
        request("http://junior.balinasoft.com/api/image", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
            print(json[1]["data"].count)
        }
    }
 
    static func deletePhotoFromServer(photoId: Int, completion: @escaping (_ result: JSON) -> ()) {
        let parameters: Parameters = ["id": photoId]
        let headers: HTTPHeaders = ["Access-Token": (Manager.user?.token)!]        
        request("http://junior.balinasoft.com/api/image/\(photoId)", method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers : headers).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
            completion(json)
        }
    }
    
    static func postCommentToSrever(text: String, imageId: Int, completion: @escaping (_ comment: JSON) -> ()) {
        let parameters: Parameters = ["imageId": imageId,
                                      "text": text]
        let headers: HTTPHeaders = ["Access-Token": (Manager.user?.token)!]
        request("http://junior.balinasoft.com/api/image/\(imageId)/comment", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers : headers).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
            completion(json)
        }
    }
    
    static func getCommentToSrever(page: Int, imageId: Int, completion: @escaping (_ comment: JSON) -> ()) {
        let parameters: Parameters = ["imageId" : imageId,
                                      "page" : page]
        let headers: HTTPHeaders = ["Access-Token": (Manager.user?.token)!]
        
        request("http://junior.balinasoft.com/api/image/3368/comment?page=\(page)", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { responseJSON in
            _ = JSON(responseJSON.result.value as Any)
        }
    }
    
    static func deleteCommentFromSrever(imageId: Int, commentId: Int, completion: @escaping (_ comment: JSON) -> ()) {
        let parameters: Parameters = ["imageId" : imageId,
                                      "commentId" : commentId]
        let headers: HTTPHeaders = ["Access-Token": (Manager.user?.token)!]
        request("http://junior.balinasoft.com/api/image/\(imageId)/comment/\(commentId)", method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers : headers).responseJSON { responseJSON in
            let json = JSON(responseJSON.result.value as Any)
            completion(json)
        }
    }
}
