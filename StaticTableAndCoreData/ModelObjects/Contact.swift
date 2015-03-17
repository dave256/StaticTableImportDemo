import CoreData

@objc(Contact) public
class Contact: _Contact {

	// Custom logic goes here.
    class func importData(moc: NSManagedObjectContext) {
        let bundle = NSBundle.mainBundle()
        let fileURL = bundle.URLForResource("names", withExtension: "txt")
        let contents = NSString(contentsOfURL: fileURL!, encoding: NSUTF8StringEncoding, error: nil)
        let lines = contents?.componentsSeparatedByString("\n") as! [String]
        for line in lines {
            let fields = line.componentsSeparatedByString(",")
            if count(fields) >= 2 {
                let c = Contact(managedObjectContext: moc)
                c.firstName = fields[0]
                c.lastName = fields[1]
                var adr: Set<EmailAddress> = []

                for (pos, address) in enumerate(fields) {
                    if pos >= 2 {
                        let email = EmailAddress(managedObjectContext: moc)
                        email.addressLabel = "Work"
                        email.email = address
                        adr.insert(email)
                        //c.addMyAddressesObject(email)
                    }
                }
                if count(adr) > 0 {
                    c.addMyAddresses(adr)
                }
            }
        }
    }

}
