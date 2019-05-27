//
//  User+CoreDataProperties.swift
//  UsersCRUD
//
//  Created by Krzysztof Błaszczyk on 20.05.2019.
//  Copyright © 2019 4iFun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var name: String?
    @NSManaged var surname: String?
    @NSManaged var phone_number: String?
    @NSManaged var address: String?

}
