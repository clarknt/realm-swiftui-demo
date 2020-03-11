//
//  RealmPersons.swift
//  RealmSwiftUIDemo
//
//  Created by clarknt on 2020-03-10.
//  Copyright © 2020 clarknt. All rights reserved.
//

import Foundation
import RealmSwift

/// Class should be created only once
/// (typically, initialize in SceneDelegate and inject where needed)
class RealmPersons: Persons {

    // MARK:- Persons conformance

    @Published private(set) var all = [Person]()

    var allPublished: Published<[Person]> { _all }
    var allPublisher: Published<[Person]>.Publisher { $all }

    init() {
        loadSavedData()
    }

    func add(person: Person) {
        let realmPerson = buildRealmPerson(person: person)
        guard write(person: realmPerson) else { return }

        if let index = all.firstIndex(where: { $0.name > person.name }) {
            all.insert(person, at: index)
        }
        else {
            all.append(person)
        }
    }

    func update(person: Person) {
        if let index = all.firstIndex(where: { $0.id == person.id }) {
            let realmPerson = buildRealmPerson(person: person)
            guard write(person: realmPerson) else { return }

            all[index] = person
            sort()
        }
        else {
            print("Person not found")
        }
    }

    func remove(persons: [Person]) {
        for (index, person) in all.enumerated() {
            for personToDelete in persons {
                if personToDelete.id == person.id {
                    let realmPerson = buildRealmPerson(person: person)
                    guard delete(person: realmPerson) else { continue }

                    all[index].deleteImage()
                    all.remove(at: index)
                }
            }
        }
    }

    // MARK: - Private functions

    private func write(person: RealmPerson) -> Bool {
        realmWrite { realm in
            realm.add(person, update: .modified)
        }
    }

    private func delete(person: RealmPerson) -> Bool {
        realmWrite { realm in
            if let person = realm.object(ofType: RealmPerson.self,
                                         forPrimaryKey: person.id) {
                realm.delete(person)
            }
        }
    }

    private func realmWrite(operation: (_ realm: Realm) -> Void) -> Bool {
        guard let realm = getRealm() else { return false }

        do {
            try realm.write { operation(realm) }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return false
        }

        return true
    }

    private func getRealm() -> Realm? {
        do {
            return try Realm()
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }

    private func loadSavedData() {
        DispatchQueue.global().async {
            guard let realm = self.getRealm() else { return }

            let objects = realm.objects(RealmPerson.self).sorted(byKeyPath: "name", ascending: true)

            let persons: [Person] = objects.map { object in
                self.buildPerson(realmPerson: object)
            }

            DispatchQueue.main.async {
                self.all = persons
            }
        }
    }

    private func buildPerson(realmPerson: RealmPerson) -> Person {
        guard let id = UUID(uuidString: realmPerson.id) else {
            fatalError("Corrupted ID: \(realmPerson.id)")
        }

        let person = Person(id: id,
                            name: realmPerson.name,
                            imagePath: realmPerson.imagePath,
                            locationRecorded: realmPerson.locationRecorded,
                            latitude: realmPerson.latitude,
                            longitude: realmPerson.longitude)

        return person
    }

    private func buildRealmPerson(person: Person) -> RealmPerson {
        let realmPerson = RealmPerson()
        realmPerson.id = person.id.uuidString
        copyPersonAttributes(from: person, to: realmPerson)

        return realmPerson
    }

    private func copyPersonAttributes(from person: Person, to realmPerson: RealmPerson) {
        realmPerson.name = person.name
        realmPerson.imagePath = person.imagePath
        realmPerson.locationRecorded = person.locationRecorded
        realmPerson.latitude = person.latitude
        realmPerson.longitude = person.longitude
    }

    private func sort() {
        all.sort(by: { $0.name < $1.name } )
    }
}
