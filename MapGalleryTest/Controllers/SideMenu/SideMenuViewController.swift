//
//  SideMenuViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 28.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var screenCoverButton: UIButton!
    
    var custom: CustomNavController!

    let menuImageArray = [#imageLiteral(resourceName: "addPhoto"), #imageLiteral(resourceName: "mapImage")]
    let menuNameArray = ["Photos", "Map"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        hideMenu()
    }
    
    func initialSetup() {
        setupContentView()
        NotificationCenter.default.addObserver(self, selector: #selector(showMenu), name: NSNotification.Name(rawValue: "MENU"), object: nil)
    }
    
    func setupContentView() {
        let customNavController = (self.storyboard?.instantiateViewController(withIdentifier: "CustomNavController"))! as! CustomNavController
        addChildViewController(customNavController)
        customNavController.view.frame = contentView.bounds
        contentView.addSubview(customNavController.view)
        customNavController.didMove(toParentViewController: self)
    }
    
    @IBAction func screenCoverButtonPressed(_ sender: UIButton) {
        hideMenu()
    }
    
    @objc func showMenu() {
        tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.menuView.alpha = 1
            self.screenCoverButton.alpha = 0.4
        }
    }
    
    func hideMenu() {
        UIView.animate(withDuration: 0.3) {
            self.menuView.alpha = 0
            self.screenCoverButton.alpha = 0
        }
    }
    
    func setUserNameCell(index: Int) -> UserNameTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserNameTableViewCell") as? UserNameTableViewCell else {
            return UserNameTableViewCell()
        }
        if let userName = Manager.user?.name {
            cell.userNameLabel.text = userName
        }
        return cell
    }
    
    func setSideMenuCell(index: Int) -> SideMenuTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as? SideMenuTableViewCell else {
            return SideMenuTableViewCell()
        }
        cell.sideImageView.image = menuImageArray[index-1]
        cell.sideMenuLabel.text = menuNameArray[index-1]
        return cell
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return setUserNameCell(index: indexPath.row)
        case 1:
            return setSideMenuCell(index: indexPath.row)
        case 2:
            return setSideMenuCell(index: indexPath.row)
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return view.frame.height/4
        case 1:
            return 70
        case 2:
            return 70
        default:
            break
        }
        return CGFloat()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            NavigationManager.customNC?.selectedIndex = indexPath.row
        case 2:
            print(indexPath.row)
            NavigationManager.customNC?.selectedIndex = indexPath.row
        default:
            break
        }
        hideMenu()
    }
}
















