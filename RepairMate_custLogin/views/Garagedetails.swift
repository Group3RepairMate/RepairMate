//
//  Garagedetails.swift
//  RepairmateHome
//
//  Created by Patel Chintan on 2023-06-08.
//

import SwiftUI
import CoreLocation
import _MapKit_SwiftUI

struct Garagedetails: View {
    var detailsview:Garage
    @State private var name : String = ""
    @State private var location : String = ""
    @State private var email : String = ""
    @State private var phone_no : String = ""
    @State private var availability:String = ""
    @State private var goToProfileSetting : Bool = false
    @State var goToCustomerDetailScreen : Bool = false
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        VStack{
            Text(detailsview.name)
//                .font(.title)
                .foregroundColor(Color("darkgray"))
                .font(.system(size: 30))
            Text("")
            VStack{
                
                Text("Location: \(detailsview.location)")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Text("")
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .frame(width: 400, height: 300)

                Text("")
                Text("")
                Text("Contact Details")
                    .padding(.top, 9)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                Text("")
            }
            VStack{
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.blue)
                    Text("Email Address:")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                    Text(detailsview.email)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    Spacer()
                }
                .padding(5)
                Text("")
                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.blue)
                    Text("Phone Number:")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                    Text(detailsview.phone_no)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    Spacer()
                }
                .padding(5)
            }
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


