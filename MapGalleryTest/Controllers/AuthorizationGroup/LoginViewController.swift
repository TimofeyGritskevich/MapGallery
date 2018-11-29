//
//  LoginViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func goToGallery()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginTF: UITextField!
    var passwordTF: UITextField!
    var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        navigationController?.navigationBar.isHidden = true
        hideKeyboardWhenTappedAround()
        buttonSetup()
    }
    
    func buttonSetup() {
        loginButton.setCorner(radius: 4)
        loginButton.setBorder()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        loginUser()
    }
    
    func loginUser() {
        if let login = loginTF.text, let password = passwordTF.text {
            NetworkManager.loginUser(login: login, password: password) { (user, error)  in
                if user != nil {
                    Manager.user = user
                    self.saveUserInfo(pass: password)
                    NavigationManager.customNC?.selectedIndex = 1
                } else {
                    if self.checkLogPass(login: login, pass: password) {
                        NavigationManager.customNC?.selectedIndex = 1
                    } else {
                        if let error = error {
                            self.setErrorAlert(errorDescription: error["error"].stringValue)
                        }
                    }
                }
            }
        }
    }
    
    func saveUserInfo(pass: String) {
        if let name = Manager.user?.name {
            Manager.saveUserName(date: name)
            Manager.savePassword(date: pass)
        }
    }
    
    func checkLogPass(login: String, pass: String) -> Bool {
        if login == Manager.loadUserName() && pass == Manager.loadPassword() {
            return true
        } else {
            return false
        }
    }
}

extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorizationTableViewCell", for: indexPath) as? AuthorizationTableViewCell else {
            return AuthorizationTableViewCell()
        }
        cell.textField.tag = indexPath.row
        cell.textField.delegate = self
        switch indexPath.row {
        case 0:
            loginTF = cell.textField
            cell.textField.placeholder = "Login"
            cell.textField.text = "timtimtim"
        case 1:
            passwordTF = cell.textField
            cell.textField.placeholder = "******"
            cell.textField.text = "46024602"
            cell.textField.isSecureTextEntry = true
        default:
            break
        }  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = view.viewWithTag(textField.tag + 1) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
    }
}

