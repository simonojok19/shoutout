//
//  SaveAccessDelete.swift
//  ShoutOutTests
//
//  Created by Simon Peter Ojok on 15/01/2022.
//  Copyright © 2022 pluralsight. All rights reserved.
//

import XCTest
import CoreData

@testable import ShoutOut

class SaveAccessDelete: XCTestCase {
    var managedContext: NSManagedObjectContext!
    var dataService: DataService!
    
    override func setUp() {
        self.managedContext = createMainContextInMemory()
        self.dataService = DataService(managedObjectContext: self.managedContext)
        self.dataService.seedEmployees()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchAllEmployees() {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        
        do {
            let employees =  try self.managedContext.fetch(employeeFetchRequest)
            print(employees)
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    func testFilterShoutOuts() {
        seedShoutOutsForTesting(managedObjectContext: self.managedContext)
        
        let shoutOutsFetchRequest = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
        let shoutOutCategoryEqualityPredicate = NSPredicate(format: "%K == %@", #keyPath(ShoutOut.shoutCategory), "Awesome Work!")
        shoutOutsFetchRequest.predicate = shoutOutCategoryEqualityPredicate
        
        do {
            let filteredOutOuts = try self.managedContext.fetch(shoutOutsFetchRequest)
            printShoutOuts(shoutOuts: filteredOutOuts)
        } catch {
            print("Error occurred")
        }
        
        
    }
    
    func seedShoutOutsForTesting(managedObjectContext: NSManagedObjectContext) {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        
        do {
            let employees = try managedObjectContext.fetch(employeeFetchRequest)
            let shoutOut1 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            
            shoutOut1.shoutCategory = "Great Job!"
            shoutOut1.message = "Hey, great job on that project"
            shoutOut1.toEmployee = employees[0]
            
            let shoutOut2 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut2.shoutCategory = "Great Job!"
            shoutOut2.message = "Couldn't have presented better at the conference last week!"
            shoutOut2.toEmployee = employees[1]
            
            let shoutOut3 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut3.shoutCategory = "Awesome Work!"
            shoutOut3.message = "You always do awesome work!"
            shoutOut3.toEmployee = employees[2]
            
            let shoutOut4 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut4.shoutCategory = "Awesome Work!"
            shoutOut4.message = "You've done an amazing job this year!"
            shoutOut4.toEmployee = employees[3]
            
            let shoutOut5 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut5.shoutCategory = "Well Done!"
            shoutOut5.message = "I'm impressed with the results of your prototype"
            shoutOut5.toEmployee = employees[4]
            
            let shoutOut6 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut6.shoutCategory = "Well Done!"
            shoutOut6.message = "Keep up the good work!"
            shoutOut6.toEmployee = employees[5]
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Something went wrong with saving ShoutOuts: \(error)")
                managedObjectContext.rollback()
            }
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    func printShoutOuts(shoutOuts: [ShoutOut]) {
        for shoutOut in shoutOuts {
            print("\n--------- ShoutOut -----------")
            print("Category: \(shoutOut.shoutCategory)")
            print("Message: \(String(describing: shoutOut.message))")
            print("To: \(shoutOut.toEmployee.firstName) \(shoutOut.toEmployee.lastName)\n")
        }
    }

}
