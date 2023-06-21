//
//  Note.swift
//  QuickNotes
//
//  Created by The Fasugba Crew  on 18/06/2023.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
    
}
