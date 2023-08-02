import SwiftUI
import CoreLocation
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct Garagedetails: View {
    var detailsview: Garage
    @State private var place: [Place] = []
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    @StateObject private var placeManager = PlaceManager()
    @State var goToCustomerDetailScreen: Bool = false
    

    var body: some View {
        VStack {
            Text(detailsview.name)
                .foregroundColor(Color("darkgray"))
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top,-50)
            
            VStack {
                Text("Location: \(detailsview.location)")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
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
//                            .foregroundColor(Color("darkgray"))
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding(.trailing,12)
                            .padding(.top,-32)
//                            .frame(width: 1)
//
                    }
                }
            }
            .onAppear {
                forwardGeocoding(address: detailsview.location)
            }
            .onReceive(placeManager.$lastKnownLocation) { location in
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
                .padding(4)
                .padding(.top,5)
                Text("")
                Button(action: {
                    let phone = detailsview.phone_no
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
                        Text(detailsview.phone_no)
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                        Spacer()
                    }
                }

                .padding(4)
                NavigationLink(destination: CustomerDetailsForm(detailsview: detailsview), isActive: $goToCustomerDetailScreen) {
                                Button(action: {
                                    self.goToCustomerDetailScreen = true
                                }) {
                                    Text("Book Now")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color("darkgray"))
                                        .cornerRadius(8)
                                        .padding(.top,20)
                                }
//                                .foregroundColor(.white)
//                                .font(.headline)
//                                .frame(maxWidth: .infinity)
//                                .background(Color("darkgray"))
//                                .cornerRadius(8)
                                .padding(5)
//                                .padding(.top,50)
                            }
                            .navigationBarTitle("", displayMode: .inline)
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
                self.place.append(Place(coordinate: coordinate))
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
        mapItem.name = detailsview.name
        mapItem.openInMaps(launchOptions: nil)
    }
}

class PlaceManager: NSObject, ObservableObject, CLLocationManagerDelegate {
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
