//
//  Persons.swift
//  RealmSwiftUIDemo
//
//  Created by clarknt on 2020-03-10.
//  Copyright © 2020 clarknt. All rights reserved.
//
import Foundation

// ObservableObject as a protocol inspired from https://stackoverflow.com/a/57657870

/// Persons
///
/// Usage (not implementation) suggestion:
/// struct SomeView<GenericRolls>: View where GenericRolls: Rolls {
///     @ObservedObject var rolls: GenericRolls
/// }
protocol Persons: ObservableObject {
    // cannot simply declare @Published var all: [Roll] { get }
    // because of the wrapped property. Use no wrapper but add
    // allPublished and allPublisher instead.

    /// Use add, update and remove functions for modification.
    /// Conformance suggestion: @Published private(set) var all = ...
    var all: [Person] { get }

    /// Conformance suggestion: var allPublished: Published<[Roll]> { _all }
    var allPublished: Published<[Person]> { get }

    /// Conformance suggestion: var allPublisher: Published<[Roll]>.Publisher { $all }
    var allPublisher: Published<[Person]>.Publisher { get }

    /// Add a person
    func add(person: Person)

    /// For demo purpose (not used in this project)
    func update(person: Person)

    /// Remove some persons
    func remove(persons: [Person])
}
