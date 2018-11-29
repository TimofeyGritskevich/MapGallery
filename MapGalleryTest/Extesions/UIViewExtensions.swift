//
//  UIViewExtensions.swift
//  MapGalleryTest
//
//  Created by Tima on 29.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func setBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 228/255, green: 233/255, blue: 236/255, alpha: 1).cgColor
    }
}
