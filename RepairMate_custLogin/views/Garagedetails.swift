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
    @State private var goToProfileSetting : Bool = false
    @State var goToCustomerDetailScreen : Bool = false
    
    var body: some View {
        VStack{
            Text(detailsview.name)
                .foregroundColor(Color("darkgray"))
                .font(.title)
                .fontWeight(.bold)
                .padding(5)
            
            Text("Location: \(detailsview.location)")
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            Text("Contact Details")
            Text("Email Address:\(detailsview.email)")
            Text("Phone Number:\(detailsview.phone_no)")
            Spacer()
            NavigationLink(destination : CustomerDetailsForm(), isActive: $goToCustomerDetailScreen){
                Button(action : {
                    self.goToCustomerDetailScreen = true
                    UserDefaults.standard.set(detailsview.name, forKey: "GARAGE")
                    UserDefaults.standard.set(detailsview.availability, forKey: "SERVICE")
                })
                {
                    Text("Book Now")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .frame(maxWidth: 120)
                }
                .background(Color("darkgray"))
                .cornerRadius(70)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.blue,lineWidth: 0)
                        .foregroundColor(.black)
                )
            }

            .navigationBarTitle("", displayMode: .inline)
        }
      
        
    }
}


