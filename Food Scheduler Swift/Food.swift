//
//  Food.swift
//  Food Scheduler Swift
//
//  Created by Robin Röcker on 29.11.22.
//

import Foundation

class Food: Codable, Identifiable{
    
    var id: String
    var name: String
    var expiryDate: Date
    
    init (id: String = UUID().uuidString, name: String, expiryDate: Date) {
        self.id = id
        self.name = name
        self.expiryDate = expiryDate
    }
}
