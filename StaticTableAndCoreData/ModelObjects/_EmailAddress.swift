// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EmailAddress.swift instead.

import CoreData

import DDRCoreDataKit

enum EmailAddressAttributes: String {
    case addressLabel = "addressLabel"
    case email = "email"
}

enum EmailAddressRelationships: String {
    case myContact = "myContact"
}

@objc public
class _EmailAddress: DDRManagedObject {

    // MARK: - Class methods

    override public class func entityName () -> String {
        return "EmailAddress"
    }

    override public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _EmailAddress.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var addressLabel: String?

    // func validateAddressLabel(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged public
    var email: String?

    // func validateEmail(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged public
    var myContact: Contact?

    // func validateMyContact(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

