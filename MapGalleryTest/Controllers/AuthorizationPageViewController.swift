//
//  AuthorizationPageViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class AuthorizationPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var loginVC: LoginViewController!
    var registrationVC: RegistrationViewController!
    
    var arrayVC: [UIViewController] = []
    
    var selectedIndex = 0 {
        didSet {
            if selectedIndex > 1 {
                selectedIndex = 1
            }
            if selectedIndex < 0 {
                selectedIndex = 0
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        self.dataSource = self
    }

    func initialSetup() {
        loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        registrationVC = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        arrayVC = [loginVC, registrationVC]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        selectedIndex = selectedIndex - 1
        return storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        selectedIndex = selectedIndex + 1
        return storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
    }
    
  
}
