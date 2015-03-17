// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Contact.swift instead.

import CoreData

import DDRCoreDataKit

enum ContactAttributes: String {
    case firstName = "firstName"
    case lastName = "lastName"
}

enum ContactRelationships: String {
    case myAddresses = "myAddresses"
}

@objc public
class _Contact: DDRManagedObject {

    // MARK: - Class methods

    override public class func entityName () -> String {
        return "Contact"
    }

    override public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Contact.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var firstName: String?

    // func validateFirstName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged public
    var lastName: String?

    // func validateLastName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged public
    var myAddresses: NSSet

}

extension _Contact {

    func addMyAddresses(objects: NSSet) {
        let mutable = self.myAddresses.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as! Set<NSObject>)
        self.myAddresses = mutable.copy() as! NSSet
    }

    func removeMyAddresses(objects: NSSet) {
        let mutable = self.myAddresses.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as! Set<NSObject>)
        self.myAddresses = mutable.copy() as! NSSet
    }

    func addMyAddressesObject(value: EmailAddress!) {
        let mutable = self.myAddresses.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.myAddresses = mutable.copy() as! NSSet
    }

    func removeMyAddressesObject(value: EmailAddress!) {
        let mutable = self.myAddresses.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.myAddresses = mutable.copy() as! NSSet
    }

}

