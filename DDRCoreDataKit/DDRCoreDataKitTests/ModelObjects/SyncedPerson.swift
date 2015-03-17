import Foundation

@objc(SyncedPerson)
public class SyncedPerson: _SyncedPerson {

    /// sets the ddrSyncIdentifier to a unique value
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        var desc = self.entity
        if desc.attributesByName["ddrSyncIdentifier"] != nil {
            self.setValue(NSUUID().UUIDString, forKey: "ddrSyncIdentifier")
        }
    }

    /// override valueForUndefinedKey: so can print an error message if user forgets to add an attribute named ddrSyncIdentifier to their CoreData model
    public override func valueForUndefinedKey(key: String) -> AnyObject {
        if key == "ddrSyncIdentifier" {
            let name = DDRManagedObject.entityName()
            println("no ddrSyncIdentifier for object of type: \(name)")
        } else {
            super.valueForUndefinedKey(key)
        }
        return ""
    }

    /// override value:forUndefinedKey so can print an error message if user forgets to add an attribute named ddrSyncIdentifier to their CoreData model
    public override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if key == "ddrSyncIdentifier" {
            println("no ddrSyncIdentifier for object of type")
        } else {
            super.setValue(value, forUndefinedKey: key)
        }
    }

}
