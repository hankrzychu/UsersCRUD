//
//  User.swift
//  UsersCRUD
//
//  Created by Krzysztof Błaszczyk on 20.05.2019.
//  Copyright © 2019 4iFun. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    convenience init(name: String, surname: String, phone_number: String, address: String, managedObjectContext: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
        self.init(entity: entity!, insertInto: managedObjectContext)
        self.name = name
        self.surname = surname
        self.phone_number = phone_number
        self.address = address
    }
    
    // returns array to present in table
    class func fiteredAndOrderedBySurname(_ surname: String, context: NSManagedObjectContext) -> [User]? {
        let request = NSFetchRequest<User>(entityName: self.entityName())
        
        let sortDscrSurname = NSSortDescriptor(key: "surname", ascending: true)
        let sortDscrName = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDscrSurname, sortDscrName]
        
        if surname != "" {
            let predicate = NSPredicate(format: "surname CONTAINS[cd] %@", surname)
            request.predicate = predicate
        }
        
        do {
            let results = try context.fetch(request)
            return results
        } catch let error as NSError {
            print("Error: \(error.debugDescription )")
            return nil
        }
    }

    
}
