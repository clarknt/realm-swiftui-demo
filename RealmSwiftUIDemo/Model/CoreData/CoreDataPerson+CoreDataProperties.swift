//
//  CoreDataPerson+CoreDataProperties.swift
//  RealmSwiftUIDemo
//
//  Created by clarknt on 2019-12-29.
//  Copyright © 2019 clarknt. All rights reserved.
//
//

import Foundation
import CoreData


extension CoreDataPerson {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CoreDataPerson> {
        return NSFetchRequest<CoreDataPerson>(entityName: "CoreDataPerson")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imagePath: String?
    @NSManaged public var internalName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locationRecorded: Bool

    public var name: String {
        get {
            internalName ?? "Unknown name"
        }

        set {
            internalName = newValue
        }
    }
}
