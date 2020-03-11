//
//  Persons.swift
//  RealmSwiftUIDemo
//
//  Created by clarknt on 2019-12-17.
//  Copyright © 2019 clarknt. All rights reserved.
//

import Foundation

class FilePersons: Persons {
    private static let personsKey = "persons"

    @Published private(set) var all = [Person]() {
        didSet {
            saveData()
        }
    }

    var allPublished: Published<[Person]> { _all }
    var allPublisher: Published<[Person]>.Publisher { $all }

    init() {
        loadData()
    }

    func add(person: Person) {
        if let index = all.firstIndex(where: { $0.name > person.name }) {
            all.insert(person, at: index)
        }
        else {
            all.append(person)
        }
    }

    // for demo purpose (not used in this project)
    func update(person: Person) {
        if let index = all.firstIndex(where: { $0.id == person.id }) {
            all[index] = person
            sort()
        }
        else {
            print("Person not found")
        }
    }

    func remove(persons: [Person]) {
        for (index, person) in all.enumerated() {
            if persons.contains(person) {
                all[index].deleteImage()
                all.remove(at: index)
            }
        }
    }

    // MARK: - Private functions

    private func loadData() {
        if let encoded = UserDefaults.standard.data(forKey: Self.personsKey) {
            do {
                let decoded = try JSONDecoder().decode([Person].self, from: encoded)
                self.all = decoded.sorted(by: sortCriteria)
            }
            catch let error {
                print("Could not decode: \(error.localizedDescription)")
            }
        }
    }

    private func saveData() {
        do {
            let encoded = try JSONEncoder().encode(all)
            UserDefaults.standard.set(encoded, forKey: Self.personsKey)
        }
        catch let error {
            print("Could not encode: \(error.localizedDescription)")
        }
    }

    private func sort() {
        all.sort(by: sortCriteria)
    }

    private func sortCriteria(p1: Person, p2: Person) -> Bool {
        p1.name < p2.name
    }
}
