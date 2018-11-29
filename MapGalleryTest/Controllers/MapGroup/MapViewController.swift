//
//  MapViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 27.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = .init(latitude: Manager.latitude, longitude: Manager.longitude)

    @IBOutlet weak var mapView: MKMapView!
    var pinArray: [CustomPin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addPins()
    }

    func initialSetup() {
        mapView.showsUserLocation = true
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        centerViewOnUserLocation()
    }
    
    func centerViewOnUserLocation() {
        let region = MKCoordinateRegion.init(center: .init(latitude: Manager.latitude, longitude: Manager.longitude), span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
    }
    
    func addPins() {
        for item in RealmManager.photoResult {
            let pin = CustomPin(pinTitle: Manager.setTimeFromUnix(unixTime: Int(item.date)), pinSubTitle: "", location: .init(latitude: item.lat, longitude: item.lng))
            pinArray.append(pin)
        }
        mapView.addAnnotations(pinArray)
    }
    
    func addPin(photo: Photo) {
        let pin = CustomPin(pinTitle: Manager.setTimeFromUnix(unixTime: Int(photo.date)), pinSubTitle: "", location: .init(latitude: photo.lat, longitude: photo.lng))
        mapView.addAnnotation(pin)
    }

    @IBAction func addOneMorePin(_ sender: UIButton) {
        getImageFromGallery()
    }
}

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
                self.addPin(photo: newPhoto)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
