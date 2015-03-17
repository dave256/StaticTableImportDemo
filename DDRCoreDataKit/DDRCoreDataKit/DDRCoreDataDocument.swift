//
//  DDRCoreDataDocument.swift
//  DDRCoreDataKit
//
//  Created by David Reed on 6/13/14.
//  Copyright (c) 2014 David Reed. All rights reserved.
//

import CoreData

/**
class for accessing a Core Data Store

uses two NSManagedObjectContext
one context of type PrivateQueueConcurrencyType is used for saving to the store to avoid blocking the main thread; this context is private to the class

the mainQueueMOC is a child context of the private context and is intended for use with the GUI

also provices a method to get a child context of this main thread

the saveContext method saves from the mainQueueMOC to the private context and do the persistent store

*/
public class DDRCoreDataDocument {

    /// the main thread/queue NSManagedObjectContext that should be used
    public let mainQueueMOC : NSManagedObjectContext!


    private let managedObjectModel : NSManagedObjectModel
    private let persistentStoreCoordinator : NSPersistentStoreCoordinator
    private let storeURL : NSURL!

    // private data
    private var privateMOC : NSManagedObjectContext! = nil

    /// create a DDRCoreDataDocument with two context; will fail (return nil) if cannot create the persistent store
    ///
    /// :param: storeURL NSURL for the SQLite store; pass nil to use an in memory store
    /// :param: modelURL NSURL for the CoreData object model (i.e., URL to the .momd file package/directory)
    /// :param: options to pass when creating the persistent store coordinator; usually [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true] for automatic migration
    public init?(storeURL: NSURL?, modelURL: NSURL, options : NSDictionary) {

        managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)!
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        var storeType : String = (storeURL != nil) ? NSSQLiteStoreType : NSInMemoryStoreType

        // try to create the persistent store
        var addError : NSError? = nil
        if !(persistentStoreCoordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options as [NSObject : AnyObject], error: &addError) != nil) {
            if let error = addError {
                println("Error adding persitent store to coordinator \(error.localizedDescription) \(error.userInfo!)")
            }
            mainQueueMOC = nil
            privateMOC = nil
            self.storeURL = nil
            return nil

        } else {
            // if everything went ok creating persistent store
            self.storeURL = storeURL
            // create the private MOC
            privateMOC = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
            privateMOC!.persistentStoreCoordinator = persistentStoreCoordinator
            privateMOC!.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

            // create the main thread/queue MOC that is a child context of the privateMOC
            mainQueueMOC = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            mainQueueMOC!.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            mainQueueMOC!.parentContext = privateMOC
        }
    }

    /// save the main and private contexts to the persistent store
    ///
    /// :param: wait true if want to wait for save to persistent store to complete; false if want to return as soon as main context saves to private context
    /// :param: error out parameter with NSError message if fails
    /// 
    /// :returns: true if save succeeds; false otherwise
    public func saveContextAndWait(wait: Bool, error: NSErrorPointer) -> Bool {
        if mainQueueMOC == nil {
            return false
        }

        var failed = false
        // if mainQueueMOC has changes, save changes up to its parent context
        if mainQueueMOC.hasChanges {
            mainQueueMOC.performBlockAndWait {
                var saveError : NSError? = nil
                if self.mainQueueMOC.save(&saveError) {
                    if let theError = saveError {
                        failed = true
                        println("error saving mainQueueMOC: \(theError.localizedDescription)")
                        if error != nil {
                            error.memory = theError
                        }
                    }
                }
            }
        }

        // closure for saving private context
        var saveClosure : () -> () = {
        var saveError : NSError? = nil
            if !self.privateMOC.save(&saveError) {
                if let theError = saveError {
                    println("error saving privateMOC: \(theError.localizedDescription)")
                    failed = true
                    if error != nil {
                        error.memory = theError
                    }
                }
            }
        }

        // save changes from privateMOC to persistent store
        if !failed {
            if privateMOC.hasChanges {
                if wait {
                    privateMOC.performBlockAndWait(saveClosure)
                }
                else {
                    privateMOC.performBlock(saveClosure)
                }
            }
        }

        if failed {
            return false
        } else {
            return true
        }
    }

    /// creates a new child NSManagedObjectContext of the main thread/queue context
    ///
    /// param: concurrencyType specifies the NSManagedObjectContextConcurrencyType for the created context
    ///
    /// :returns: the created NSManagedObjectContext
    public func newChildOfMainObjectContextWithConcurrencyType(concurrencyType : NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        var moc = NSManagedObjectContext(concurrencyType: concurrencyType)
        moc.parentContext = mainQueueMOC
        return moc
    }
}
