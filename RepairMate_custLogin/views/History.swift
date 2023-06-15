//
//  History.swift
//  RepairMate
//
//  Created by Patel Chintan on 2023-06-14.
//

import Foundation
struct History: Identifiable {
    let id = UUID()
    let location: String
    let dateTime: Date
    let garagename: String
    
    init(location: String, dateTime: Date, garagename: String) {
        self.location = location
        self.dateTime = dateTime
        self.garagename = garagename
    }
}
