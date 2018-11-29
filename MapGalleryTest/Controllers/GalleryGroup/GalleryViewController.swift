//
//  GalleryViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit



class GalleryViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var gallery = RealmManager.photoResult
    var imagePicker = UIImagePickerController()
    var imageStr = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func initalSetup() {
        addGesture()
        navigationSetup()
    }
    
    func navigationSetup() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    func addGesture() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    @IBAction func addNewPhotoButtonPressed(_ sender: UIButton) {
        getImageFromGallery()
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            return
        }
        let press = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: press)
        if let index = indexPath {
            showAlertForDelete(index: index.row)
        }
    }
    
    func showAlertForDelete(index: Int) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure??", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.deletePhoto(index: index)
        }))
        alert.addAction(UIAlertAction(title: "Not", style: .cancel, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletePhoto(index: Int) {
        let photo = gallery[index]
        NetworkManager.deletePhotoFromServer(photoId: photo.id) { (json) in
            if json["status"].intValue == 200 {
                self.deleteComments(photoId: photo.id)
                RealmManager.deletePhotoFromRealm(photo: photo)
                self.collectionView.reloadData()
            }
        }
    }
    
    func deleteComments(photoId: Int) {
        let photoComments = RealmManager.realm.objects(Comment.self).filter("imageId = %d", photoId)
        for comment in photoComments {
            NetworkManager.deletePhotoFromServer(photoId: comment.imageId, completion: { (true) in
                try! RealmManager.realm.write {
                    RealmManager.realm.delete(comment)
                }
            })
        }
    }
}
extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gallery.count != 0 {
            return gallery.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as? GalleryCollectionViewCell else {
            return GalleryCollectionViewCell()
        }
        let item = gallery[indexPath.row]
        cell.loadWith(photo: item)
        print(item.lat, item.lng, item.date, item.id)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailsViewController") as? PhotoDetailsViewController {
            let item = gallery[indexPath.row]
            controller.photo = item
            navigationController?.pushViewController(controller, animated: true) 
        }
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getImageFromGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        if let stringPhoto = image.base64(format: .jpeg(0.1)) {
            NetworkManager.postPhotToServer(imageString: stringPhoto) { (json) in
                let newPhoto = Photo(date: json["data"]["date"].intValue,
                                     id: json["data"]["id"].intValue,
                                     lat: json["data"]["lat"].doubleValue,
                                     lng: json["data"]["lng"].doubleValue,
                                     imageStr: stringPhoto)
                
                RealmManager.savePhotToRealm(photo: newPhoto)
                self.collectionView.reloadData()
            }
        } 
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}












