//
//  CommentTableViewCell.swift
//  MapGalleryTest
//
//  Created by Tima on 27.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    func loadWith(comment: Comment) {
        self.messageTextView.text = comment.title
        self.dateLabel.text = Manager.setTimeFromUnix(unixTime: comment.date)
        self.messageView.setCorner(radius: 8)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
