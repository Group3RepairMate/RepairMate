//
//  Notification.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-08-03.
//

import SwiftUI

struct Notification: View {
    var notification:Notify
    var body: some View {
        VStack{
            Text("From \(notification.from)")
            Text(notification.msg)
        }
    }
}
