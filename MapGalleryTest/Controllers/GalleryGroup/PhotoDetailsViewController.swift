//
//  PhotoDetailsViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 27.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var botConstr: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!

    var textHolder = ""
    var photo: Photo?
    var photoComments = RealmManager.realm.objects(Comment.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    func initialSetup() {
        navigationController?.navigationBar.isHidden = true
        commentTextField.delegate = self
        hideKeyboardWhenTappedAround()
        registerForKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        botConstr.constant = kbFrameSize.height
        view.layoutIfNeeded()
    }
    
    @objc func kbWillHide() {
        botConstr.constant = 0
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationManager.customNC?.backButton.setImage(#imageLiteral(resourceName: "Back Arrow"), for: .normal)
        NavigationManager.customNC?.isBackButtonMenu = false
        if let url = self.photo?.imageStr, let date = self.photo?.date {
            DispatchQueue.main.async {
                self.photoComments = RealmManager.realm.objects(Comment.self).filter("imageId = %d", self.photo?.id as Any)
                self.photoImageView.image = Manager.setImageFromString(str: url)
                self.setImageViewSize(imageSize: Manager.setImageFromString(str: url).size)
                self.photoDateLabel.text = Manager.setTimeFromUnix(unixTime: Int(date))
            }
        }
    }

    func setImageViewSize(imageSize: CGSize) {
        if imageSize.width > view.frame.size.width && imageSize.width > imageSize.height {
            let newHeight = view.frame.size.width*imageSize.height/imageSize.width
            imageViewHeight.constant = newHeight
        } else {
            imageViewHeight.constant = 300
        }
        view.layoutIfNeeded()
    }
    
    @IBAction func addComment(_ sender: UIButton) {
        if textHolder != "" {     
           addNewComment()
        }
    }
    
    func addNewComment() {
        if let imageId = photo?.id {
            NetworkManager.postCommentToSrever(text: textHolder, imageId: imageId) { (json) in
                let newComment = Comment(title: json["data"]["text"].stringValue,
                                         date: json["data"]["date"].intValue,
                                         id: json["data"]["id"].intValue,
                                         imageId: imageId)
                RealmManager.saveCommentToRealm(comment: newComment)
                self.textHolder = ""
                self.commentTextField.text = ""
                self.tableView.reloadData()
                let indexPath = IndexPath(row: RealmManager.commentResult.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func deleteComment(index: Int) {
        let comment = photoComments[index]
        NetworkManager.deleteCommentFromSrever(imageId: comment.imageId, commentId: comment.id) { (json) in
            if json["status"].intValue == 200 {
                RealmManager.deleteCommentFromRealm(comment: comment)
            }
            self.tableView.reloadData()
        }
    }
}

extension PhotoDatailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if photoComments.count != 0 {
            return photoComments.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else {
            return CommentTableViewCell()
        }
        let item = photoComments[indexPath.row]
        cell.loadWith(comment: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let string = photoComments[indexPath.row].title
        let width = Double(view.frame.size.width - 56)
        let height = UIFont.systemFont(ofSize: 13).sizeOfString(string: string, constrainedToWidth: width).height
        return height + 28
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteComment(index: indexPath.row)
        }
    }
}

extension PhotoDatailsViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textHolder = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
}
