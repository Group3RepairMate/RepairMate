//
//  Notification.swift
//  RepairMate
//
//  Created by Harshil Vaghani on 2023-08-03.
//

import SwiftUI

struct Notification: View {
    var notification: Notify
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.brown)
                    .padding(.top, -20)
                Text("\(notification.from)")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("")
                Text("")
                Text("")

            }
            Text(notification.msg)
                .foregroundColor(.black)
                .font(.body)
                .background(Color.white)
                .padding()
            Spacer()
        }
        .padding()
      
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
    }
}
