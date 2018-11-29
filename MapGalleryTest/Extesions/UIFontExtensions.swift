//
//  UIFontExtensions.swift
//  MapGalleryTest
//
//  Created by Tima on 29.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Foundation

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [kCTFontAttributeName as NSAttributedStringKey: self],
                                                     context: nil).size
    }
}
