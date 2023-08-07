import SwiftUI
import CoreLocation
import MapKit
import FirebaseAuth
import Firebase

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct CustomerDetail: View {
    var detailsview: Order
    @State private var place: [Location] = []
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @StateObject private var locationManager = LocationManager()
    @State var goToCustomerDetailScreen: Bool = false
    @AppStorage("mechanicId") var mechanicId: String = ""
    @State private var showingAlert = false
    @State private var isAccepted = false
    
    var body: some View {
        if mechanicId == "" {
            AuthView()
        }
        VStack {
            Text("Customer Details")
                .foregroundColor(Color("darkgray"))
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top, -43)
                .padding(5)
            Text("\(detailsview.firstName) \(detailsview.lastName)")
                .foregroundColor(.brown)
                .font(.title2)
                .fontWeight(.medium)
            
            Text("")
            
            VStack {
                Text("Location: \(detailsview.apartment) \(detailsview.streetname) \(detailsview.city)")
                    .fontWeight(.regular)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                Text("")
                Map(coordinateRegion: $region, annotationItems: place) { place in
                    MapMarker(coordinate: place.coordinate, tint: Color("darkgray"))
                }
                .padding(15)
                .frame(width: 400, height: 300)
                
                Text("")
                Text("")
                Button(action: {
                    openAppleMaps(latitude: place.first?.coordinate.latitude, longitude: place.first?.coordinate.longitude)
                }) {
                    HStack {
                        Spacer()
                        Image("direction")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding(.trailing,12)
                            .padding(.top,-32)
                        
                    }
                }
                
                
                
            }
            .onAppear {
                forwardGeocoding(address: "\(detailsview.apartment) \(detailsview.streetname) \(detailsview.city)")
            }
            .onReceive(locationManager.$lastKnownLocation) { location in
                guard let userLocation = location else { return }
                region.center = userLocation.coordinate
            }
            
            VStack {
                
                Button(action: {
                    let email = detailsview.email
                    let urlgmail = URL(string: "googlegmail://co?to=\(email)")!
                    if UIApplication.shared.canOpenURL(urlgmail) {
                        UIApplication.shared.open(urlgmail)
                    } else {
                        let site = URL(string: "https://mail.google.com/mail/?view=cm&fs=1&to=\(email)")!
                        UIApplication.shared.open(site)
                    }
                }) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        Text("Email:")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                        Text(detailsview.email)
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                        Spacer()
                    }
                }
                .padding(5)
                .padding(.top,10)
                Text("")
                Button(action: {
                    let phone = detailsview.contactNo
                    let dialstr = "tel://\(phone)"
                    if let dial = URL(string: dialstr) {
                        UIApplication.shared.open(dial)
                    }
                }) {
                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.blue)
                        Text("Phone:")
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                        Text(detailsview.contactNo)
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                        Spacer()
                    }
                }
                .padding(4)
                ZStack{
                    HStack{
                        Button(action:{
                            Firestore.firestore().collection("customers").document(detailsview.email).collection("Orderlist").document(detailsview.bookingId).updateData([
                                "status":"accepted"
                            ])
                            { error in
                                if let error = error {
                                    showingAlert = true
                                } else {
                                    showingAlert = true
                                    isAccepted = true
                                }
                            }
                        })
                        {
                            Text("Accept")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding(15)
                                .frame(maxWidth: .infinity)
                        }
                        .background(Color.green)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 60)
                                .stroke(Color.blue,lineWidth: 0)
                                .foregroundColor(.black)
                        )
                        .padding(.leading,30)
                        .padding(.top,80)
                        
                        Spacer()
                        Button(action:{
                            Firestore.firestore().collection("customers").document(detailsview.email).collection("Orderlist").document(detailsview.bookingId).updateData([
                                "status":"deleted"
                            ])
                            { error in
                                if let error = error {
                                    showingAlert = true
                                } else {
                                    showingAlert = true
                                    isAccepted = false
                                }
                            }
                        })
                        {
                            HStack{
                                
                                Text("Decline")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding(15)
                                    .frame(maxWidth: .infinity)
                            }
                            .background(Color.red)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 60)
                                    .stroke(Color.red,lineWidth: 0)
                                    .foregroundColor(.black)
                            )
                            .padding(.trailing,30)
                            .padding(.top,80)
                        }
                        
                        .alert(isPresented: $showingAlert) {
                            if isAccepted {
                                return Alert(title: Text("Successful"), message: Text("Order accepted."), dismissButton: .default(Text("OK")))
                                
                            } else {
                                return Alert(title: Text("Failed"), message: Text("Order cannot be accepted"), dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                    
                }
            }
            Spacer()
            
            
        }
    }
    
    func forwardGeocoding(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if error != nil {
                print("Failed to retrieve location")
                return
            }
            
            if let placemark = placemarks?.first,
               let location = placemark.location {
                let coordinate = location.coordinate
                self.place.append(Location(coordinate: coordinate))
                print("\(address)")
                print("\nlat: \(coordinate.latitude), long: \(coordinate.longitude)")
            } else {
                print("No Matching Location Found")
            }
        }
    }
    
    func openAppleMaps(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = detailsview.streetname + detailsview.city
        mapItem.openInMaps(launchOptions: nil)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lastKnownLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
