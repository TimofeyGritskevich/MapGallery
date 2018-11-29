//
//  AuthorizationViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollIndicator: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var loc = LocationManager()
    var vcArray: [UIViewController]!
    var loginVC: LoginViewController!
    var registrationVC: RegistrationViewController!
    
    var selectedIndex = 0 {
        didSet {
            scrollMove()
            setSelectedSection()
            collectionView.reloadData()
        }
    }
    
    let tabbarCellLabels = ["Login", "Registration"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        navigationController?.navigationBar.isHidden = true
        controllersSetup()
        setSelectedSection()
    }
    
    func controllersSetup() {
        loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        registrationVC = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        vcArray = [loginVC, registrationVC]
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
    
    func scrollMove() {
        UIView.animate(withDuration: 0.3) {
            self.scrollIndicator.frame.origin.x = self.scrollIndicator.frame.width*CGFloat(self.selectedIndex)
        }
    }
}

extension AuthorizationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorizationCollectionViewCell", for: indexPath) as? AuthorizationCollectionViewCell else {
            return AuthorizationCollectionViewCell()
        }
        cell.tabbarLabel.text = tabbarCellLabels[indexPath.item]
        
        if indexPath.item != selectedIndex {
            cell.tabbarLabel.textColor = UIColor(red: 181/255, green: 216/255, blue: 141/255, alpha: 1)
        } else {
            cell.tabbarLabel.textColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
    }
}













