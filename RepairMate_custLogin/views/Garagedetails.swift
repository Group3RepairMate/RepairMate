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

    @StateObject private var locationManager = LocationManager()
    @State var goToCustomerDetailScreen: Bool = false
    

    var body: some View {
        VStack {
            Text(detailsview.name)
                .foregroundColor(Color("darkgray"))
                .font(.system(size: 30))
                .fontWeight(.semibold)
            Text("")

            VStack {
                Text("Location: \(detailsview.location)")
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Text("")
                Map(coordinateRegion: $region, annotationItems: place) { place in
                    MapMarker(coordinate: place.coordinate, tint: Color("darkgray"))
                }
                .frame(width: 400, height: 300)

                Button(action: {
                    openAppleMaps(latitude: place.first?.coordinate.latitude, longitude: place.first?.coordinate.longitude)
                }) {
                    Text("Get Directions")
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
                        .stroke(Color.blue, lineWidth: 0)
                        .foregroundColor(.black)
                )
            }
            .onAppear {
                forwardGeocoding(address: detailsview.location)
            }
            .onReceive(locationManager.$lastKnownLocation) { location in
                guard let userLocation = location else { return }
                region.center = userLocation.coordinate
            }

            VStack {
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
                NavigationLink(destination: CustomerDetailsForm(), isActive: $goToCustomerDetailScreen) {
                                Button(action: {
                                    self.goToCustomerDetailScreen = true
                                    UserDefaults.standard.set(detailsview.name, forKey: "GARAGE")
                                    UserDefaults.standard.set(detailsview.availability, forKey: "SERVICE")
                                }) {
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
                                        .stroke(Color.blue, lineWidth: 0)
                                        .foregroundColor(.black)
                                )
                            }
                            .navigationBarTitle("", displayMode: .inline)
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
