//
//  Garagedetails.swift
//  RepairmateHome
//
//  Created by Patel Chintan on 2023-06-08.
//

import SwiftUI
import CoreLocation
import _MapKit_SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct Garagedetails: View {
    var detailsview:Garage
    @State private var place : [Place] = []
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
                .fontWeight(.semibold)
            Text("")
            VStack{
                
                Text("Location: \(detailsview.location)")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Text("")
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow),annotationItems: place){
                    MapMarker(coordinate: $0.coordinate,
                              tint: Color("darkgray"))
                }
                .frame(width: 400, height: 300)
                
                Button(action: {
                    openAppleMaps(latitude: self.place[0].coordinate.latitude, longitude: self.place[0].coordinate.longitude)
                }) {
                    Text("Get Direction")
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
                    Text("Email:")
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
                    Text("Phone:")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                    Text(detailsview.phone_no)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    Spacer()
                }
                .padding(5)
            }
            
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
        .onAppear(){
            self.forwardGeocoding(address: detailsview.location)
        }
        
    }
    
    func forwardGeocoding(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print("Failed to retrieve location")
                return
            }
            
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                let coordinate = location.coordinate
                self.place.append(Place(coordinate: coordinate))
                print("\(address)")
                print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
            }
            else
            {
                print("No Matching Location Found")
            }
        })
    }
    
    func openAppleMaps(latitude:CLLocationDegrees,longitude:CLLocationDegrees) {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}


