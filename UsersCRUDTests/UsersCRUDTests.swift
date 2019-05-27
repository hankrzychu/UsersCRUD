//
//  UsersCRUDTests.swift
//  UsersCRUDTests
//
//  Created by Krzysztof Błaszczyk on 20.05.2019.
//  Copyright © 2019 4iFun. All rights reserved.
//

import XCTest
import CoreData

@testable import UsersCRUD

class UsersCRUDTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        let modelURL = Bundle.main.url(forResource: "UsersCRUD", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        _ = try? coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        
    }
    
    func initialRecordCreate () -> User {
        let user = User(name: "John", surname: "Appleseed", phone_number: "1234245", address: "Cupertino", managedObjectContext:managedObjectContext)
        return user
    }
    
    func testExistingUserEntityDefinition() {
        XCTAssertEqual(User.count(managedObjectContext), 0, "User managed object class should be defined")
    }
    
    func testCreate() {
        let user = initialRecordCreate()
        XCTAssertNotNil(user, "Entity should not be nil")
    }
    
    func testRead() {
        let user = initialRecordCreate()
        XCTAssertEqual(user.name, "John")
        XCTAssertEqual(user.surname, "Appleseed")
    }
    
    func testUpdate() {
        let user = initialRecordCreate()
        XCTAssertEqual(user.name, "John")
        user.name = "Tom"
        XCTAssertEqual(user.name, "Tom")
    }
    
    func testDelete() {
        let user = initialRecordCreate()

        XCTAssertEqual(User.count(managedObjectContext), 1, "One User object should be defined")
        managedObjectContext.delete(user)
        XCTAssertEqual(User.count(managedObjectContext), 0, "No User object should be defined")
    }
    
}
