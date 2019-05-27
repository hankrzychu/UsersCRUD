//
//  ViewController.swift
//  UsersCRUD
//
//  Created by Krzysztof Błaszczyk on 20.05.2019.
//  Copyright © 2019 4iFun. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UISearchBar!
    
    var users = [User]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = User.fiteredAndOrderedBySurname("", context: managedObjectContext)!
    }
    
    // MARK: segueing
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editUser" {
            let editUserViewController = segue.destination as! EditUserViewController
   
            // get current user cell
            if let selectedUserCell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: selectedUserCell)!
                let selectedUser = users[(indexPath as NSIndexPath).row]
                editUserViewController.user = selectedUser
            }
        }
    }

    @IBAction func unwindToUsers(_ segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? EditUserViewController,
               let user = sourceViewController.user {
            
            do {
                try managedObjectContext.save()
                users = User.fiteredAndOrderedBySurname( searchView.text!, context: managedObjectContext)!
                tableView.reloadData()
                if let id = users.firstIndex(of: user) {
                    let idPath = IndexPath(row: id, section:0)
                    tableView.selectRow(at: idPath, animated: true, scrollPosition: .middle)
                }
            } catch {
                print("Failed to save users...")
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usercell")!
        let user = users[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(user.surname!) \(user.name!),   \(user.phone_number!)"
        cell.detailTextLabel?.text = user.address!
        
        return cell
    }
    
    // Delete user
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[(indexPath as NSIndexPath).row]
            
            // Delete from CoreData, data model & tableView row
            managedObjectContext.delete(user)
            users.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UISearchBarDelegate
extension UsersViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users = User.fiteredAndOrderedBySurname(searchText, context: managedObjectContext)!
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
