//
//  RealPerson.swift
//  RealmSwiftUIDemo
//
//  Created by clarknt on 2020-03-10.
//  Copyright © 2020 clarknt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmPerson: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var imagePath: String? = nil
    @objc dynamic var locationRecorded: Bool = false
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}
