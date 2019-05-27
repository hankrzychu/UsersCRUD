//
//  NSManagedObject+Common.swift
//  UsersCRUD
//
//  Created by Krzysztof Błaszczyk on 20.05.2019.
//  Copyright © 2019 4iFun. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    // proper name of descendant class
    class func entityName() -> String {
        let classString = NSStringFromClass(self)
        // The entity is the last component of dot-separated class name
        let components = classString.components(separatedBy: ".")
        return components.last ?? classString
    }
    
    // count of existing CoreData objects of the specific class  
    class func count(_ context: NSManagedObjectContext) -> Int {
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.entityName())
        
        do {
            let results = try context.fetch(request) as! [NSManagedObject]
            return results.count
        } catch let error as NSError {
            print("Error: \(error.debugDescription )")
            return 0
        }
    }
        
}

