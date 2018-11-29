//
//  CustomNavController.swift
//  MapGalleryTest
//
//  Created by Tima on 29.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class CustomNavController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var navigationView: UIView!
    
    var isBackButtonMenu = true
    var authorizationVC: AuthorizationViewController!
    var galleryVC: GalleryViewController!
    var mapVC: MapViewController!
    var vcArray:[UIViewController]!
    
    var selectedIndex = 0 {
        didSet {
            backButton.isHidden = false
            removePreviousSection()
            setSelectedSection()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
    }
    
    func initalSetup() {
        NavigationManager.customNC = self
        controllersSetup()
        setSelectedSection()
        backButton.isHidden = true
    }
  
    func controllersSetup() {
        authorizationVC = storyboard?.instantiateViewController(withIdentifier: "AuthorizationViewController") as! AuthorizationViewController
        galleryVC = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let galleryNavVC = UINavigationController(rootViewController: galleryVC)
        vcArray = [authorizationVC, galleryNavVC, mapVC]
    }
    
    func removePreviousSection() {
        let previousIndex = selectedIndex
        let previousVC = vcArray[previousIndex]
        previousVC.willMove(toParentViewController: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParentViewController()
    }
    
    func setSelectedSection() {
        let vc = vcArray[selectedIndex]
        addChildViewController(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        if isBackButtonMenu {
            showMenu()
        } else {
            let controller =  vcArray[selectedIndex] as? UINavigationController
            controller?.popViewController(animated: true) 
            backButton.setImage(#imageLiteral(resourceName: "navBarMenu"), for: .normal)
            isBackButtonMenu = true
        }
    }
    
    @objc func showMenu() {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "MENU"), object: nil)
    }
}
