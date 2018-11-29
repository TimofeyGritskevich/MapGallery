//
//  RegistrationViewController.swift
//  MapGalleryTest
//
//  Created by Tima on 26.11.2018.
//  Copyright © 2018 Timofey Gritkevich. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var singButton: UIButton!

    var loginTF: UITextField!
    var passwordTF: UITextField!
    var checkPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        hideKeyboardWhenTappedAround()
        navigationController?.navigationBar.isHidden = true
        buttonSetup()
    }
    
    func buttonSetup() {
        singButton.setCorner(radius: 4)
        singButton.setBorder()
    }
    
    @IBAction func singButtonPressed(_ sender: UIButton) {
        if checkPass() {
            singUp()
        }
    }
    
    func singUp() {
        if let login = loginTF.text, let password = passwordTF.text {
            if login != "" {
                NetworkManager.registerUser(login: login, password: password) { (user, error)  in
                    if user != nil {
                        Manager.user = user
                        self.saveUserInfo(pass: password)
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
    
    func checkPass() -> Bool {
        if passwordTF.text == checkPasswordTF.text {
            return true
        }
        self.setErrorAlert(errorDescription: "не совпадают пароли")
        return false
    }
}

extension RegistrationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
        case 1:
            passwordTF = cell.textField
            cell.textField.placeholder = "******"
            cell.textField.isSecureTextEntry = true
        case 2:
            checkPasswordTF = cell.textField
            cell.textField.placeholder = "******"
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

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = view.viewWithTag(textField.tag + 1) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            dismissKeyboard()
        }
        return true
    }
}

  


