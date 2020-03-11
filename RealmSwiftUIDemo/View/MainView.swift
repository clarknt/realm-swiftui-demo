//
//  MainView.swift
//  RealmSwiftUIDemo
//
//  Created by clarknt on 2019-12-17.
//  Copyright © 2019 clarknt. All rights reserved.
//

import SwiftUI

struct MainView<GenericPersons: Persons>: View {
    @ObservedObject var persons: GenericPersons
    @State var showingAddContact = false

    init(persons: GenericPersons) {
        self.persons = persons
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(persons.all) { person in
                    NavigationLink(destination: DetailView(person: person)) {
                        self.getImage(for: person)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(10)
                            // for placeholders
                            .foregroundColor(Color.gray)
                        Text(person.name)
                    }
                }
                .onDelete { offsets in
                    var persons = [Person]()
                    for offset in offsets {
                        persons.append(self.persons.all[offset])
                    }
                    self.persons.remove(persons: persons)
                }
            }
            .navigationBarTitle("Event contacts")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddContact = true
                }) {
                    Image(systemName: "plus")
                        // increase tap area size
                        .padding(15)
                }
            )
        }
        .sheet(isPresented: $showingAddContact) {
            AddContact(persons: self.persons)
        }
    }

    func getImage(for person: Person) -> Image {
        if let imageData = person.getImage() {
            if let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }

        return Image(systemName: "person.crop.square")
    }
}

struct MainView_Previews: PreviewProvider {
    static let persons = [Person]()

    class PreviewPersons: Persons {
        @Published private(set) var all: [Person]
        var allPublished: Published<[Person]> { _all }
        var allPublisher: Published<[Person]>.Publisher { $all }
        init(persons: [Person]) { self.all = persons }
        func add(person: Person) { }
        func insert() { }
        func update(person: Person) { }
        func remove(persons: [Person]) { }
    }

    static var previews: some View {
        MainView(persons: PreviewPersons(persons: persons))
    }
}
