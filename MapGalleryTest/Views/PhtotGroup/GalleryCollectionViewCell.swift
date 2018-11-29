//
//  GalleryCollectionViewCell.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func loadWith(photo: Photo) {
        DispatchQueue.main.async {
            self.photoImageView.image = Manager.setImageFromString(str: photo.imageStr)
            self.dateLabel.text = Manager.setTimeFromUnix(unixTime: Int(photo.date))
        }
    }
    
}
