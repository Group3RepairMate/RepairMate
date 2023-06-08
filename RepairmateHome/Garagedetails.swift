//
//  Garagedetails.swift
//  RepairmateHome
//
//  Created by Patel Chintan on 2023-06-08.
//

import SwiftUI

struct Garagedetails: View {
    var detailsview:Garage
    @State private var name : String = ""
    @State private var location : String = ""
    @State private var email : String = ""
    @State private var phone_no : String = ""
    @State private var availability:String = ""
    
    var body: some View {
        VStack{
            Text(detailsview.name)
                .foregroundColor(.blue)
                .font(.title)
                .fontWeight(.bold)
                .padding(5)
            
            Text("Location: \(detailsview.location)")
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            Text("Contact Details")
            Text("Email Address:\(detailsview.email)")
            Text("Phone Number:\(detailsview.phone_no)")
            
        }
        Spacer()
        
    }
}


