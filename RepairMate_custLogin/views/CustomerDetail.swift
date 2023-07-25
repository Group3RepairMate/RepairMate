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
        VStack {
            Text("\(detailsview.firstName) \(detailsview.lastName)")
                .foregroundColor(Color("darkgray"))
                .font(.system(size: 28))
                .fontWeight(.semibold)

            VStack {
                Text("Location: \(detailsview.apartment) \(detailsview.streetname) \(detailsview.city)")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                
                Map(coordinateRegion: $region, annotationItems: place) { place in
                    MapMarker(coordinate: place.coordinate, tint: Color("darkgray"))
                }
                .padding(15)
                .frame(width: 400, height: 300)
                
                Button(action: {
                    openAppleMaps(latitude: place.first?.coordinate.latitude, longitude: place.first?.coordinate.longitude)
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .padding(.leading,0)
                            .frame(width: 1)
                        Text("Get Directions")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 15)
                            .frame(width: 130)
                      
                    }
                }
                .padding(.horizontal, 25)
                .background(Color("darkgray"))
                .cornerRadius(70)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.blue, lineWidth: 0)
                        .foregroundColor(.black)
                )

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
                            .font(.system(size: 15))
                        Text(detailsview.email)
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        Spacer()
                    }
                }
                .padding(5)
                .padding(.top,10)

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
                            .font(.system(size: 15))
                        Text(detailsview.contactNo)
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                        Spacer()
                    }
                }
                
                Button(action:{
                    Firestore.firestore().collection("customers").document(detailsview.email).collection("Orderlist").document(detailsview.bookingId).updateData([
                        "status":"accepted"
                    ])
                    { error in
                        if let error = error {
                            print("accept: \(error)")
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
