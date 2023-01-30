//
//  ContentView.swift
//  Food Scheduler Swift
//
//  Created by Robin Röcker on 06.11.22.
//

import SwiftUI

struct foodItem: Identifiable {
    let name: String
    let category: String
    let expirationDate: Date
    let id = UUID()
}

struct Person: Identifiable {
    let givenName: String
    let familyName: String
    let emailAddress: String
    let id = UUID()
}

private var people = [
    Person(givenName: "Juan", familyName: "Chavez", emailAddress: "juanchavez@icloud.com"),
    Person(givenName: "Mei", familyName: "Chen", emailAddress: "meichen@icloud.com"),
    Person(givenName: "Tom", familyName: "Clark", emailAddress: "tomclark@icloud.com"),
    Person(givenName: "Gita", familyName: "Kumar", emailAddress: "gitakumar@icloud.com")
]

private var foodItemsList = [
    foodItem(name: "Tomaten", category: "Berry", expirationDate: Date.now.addingTimeInterval(172800)),
    foodItem(name: "Brot", category: "Berry", expirationDate: Date.now.addingTimeInterval(345600)),
    foodItem(name: "Milch", category: "Berry", expirationDate: Date.now.addingTimeInterval(604800)),
]

struct ContentView: View {
    var body: some View {
        Table(people) {
            TableColumn("Given Name", value: \.givenName)
            TableColumn("Family Name", value: \.familyName)
            TableColumn("E-Mail Address", value: \.emailAddress)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
