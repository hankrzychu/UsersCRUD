//
//  EditUserViewController.swift
//  UsersCRUD
//
//  Created by Krzysztof Błaszczyk on 20.05.2019.
//  Copyright © 2019 4iFun. All rights reserved.
//

import Foundation

import UIKit

class EditUserViewController: UIViewController {

    var user: User?
    
    weak var activeTextField: UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var surnameTextView: UITextField!
    @IBOutlet weak var telephoneNumberTextView: UITextField!
    @IBOutlet weak var addressTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if there is editing existing user
        if let user = user {
            navigationItem.title = "Edit User"
            nameTextView.text   = user.name
            surnameTextView.text = user.surname
            telephoneNumberTextView.text = user.phone_number
            addressTextView.text = user.address
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // check enabling of the Save button
        checkIfCanBeSaved()
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        if let activeField = activeTextField, let keyboardSize = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func checkIfCanBeSaved() {
        
        // there is an edit operation
        if let user = user {
            
            // user fields didn't change
            if  user.name == nameTextView.text &&
                user.surname == surnameTextView.text &&
                user.phone_number == telephoneNumberTextView.text &&
                user.address == addressTextView.text {
                
                saveButton.isEnabled = false
                return
            }
        }
        
        let name = nameTextView.text ?? ""
        let surname = surnameTextView.text ?? ""
        let phone = telephoneNumberTextView.text ?? ""
        let address = addressTextView.text ?? ""
        
        // Disable the Save button if the text field is empty.
        saveButton.isEnabled = !name.isEmpty && !surname.isEmpty && !phone.isEmpty && !address.isEmpty
    }

    @IBAction func cancel(_ sender: AnyObject) {
        // This view controller needs to be dismissed in one of two different ways.
        let isPresentingInAddUserMode = presentingViewController is UINavigationController
        
        if isPresentingInAddUserMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController!.popViewController(animated: true)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIBarButtonItem, saveButton === sender {
            
            let name = nameTextView.text
            let surname = surnameTextView.text
            let phone = telephoneNumberTextView.text
            let address = addressTextView.text
            
            if let user = user {
                
                // there was Edit User operation
                user.name = name
                user.surname = surname
                user.phone_number = phone
                user.address = address
                
            } else {
                let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext

                // there was New User operation
                user = User(name: name!, surname: surname!, phone_number: phone!, address: address!, managedObjectContext: managedObjectContext)
                managedObjectContext.insert(user!)
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension EditUserViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfCanBeSaved()
        activeTextField = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == telephoneNumberTextView
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingPlus = newString.count > 0 && (newString as NSString).substring(with: NSMakeRange(0, 1)) == "+"
            
            var index = 0
            let formattedString = NSMutableString()
            
            if hasLeadingPlus {
                if length > 2 {
                    let countryCode = decimalString.substring(with: NSMakeRange(index, 2))
                    formattedString.appendFormat("+%@ ", countryCode)
                    index += 2
                } else {
                    formattedString.appendFormat("+%@", decimalString)
                    textField.text = formattedString as String
                    return false
                }
            }
            if length - index < 11 {
                if length - index > 3
                {
                    let section1 = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("%@ ", section1)
                    index += 3
                }
                if length - index > 3
                {
                    let section2 = decimalString.substring(with: NSMakeRange(index, 3))
                    formattedString.appendFormat("%@ ", section2)
                    index += 3
                }
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        return true
    }
    
}
