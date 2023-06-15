import SwiftUI
import Firebase

struct Homescreen: View {
    
    @State private var useremail: String = ""
    @State private var password: String = ""
    @State private var createaccount: Int? = nil
    @State private var homeview: Int? = nil
    @State var errormessage = false
    @State var isAlert = false
    @State private var searchlocation = ""
    @State private var searchText = ""
    @EnvironmentObject var garagehelper: Garagehelper
    
    enum ServiceType {
        case immediate
        case advance
        case all
    }
    
    @State private var selectedServiceType: ServiceType = .all
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Garage List")
                    .foregroundColor(Color("darkgray"))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Picker("Service", selection: $selectedServiceType) {
                    Text("All").tag(ServiceType.all)
                    if garagehelper.garagelist.contains(where: { $0.availability == "Immediate" }) {
                        Text("Immediate").tag(ServiceType.immediate)
                    }
                    if garagehelper.garagelist.contains(where: { $0.availability == "Advance" }) {
                        Text("Advance").tag(ServiceType.advance)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            
                List {
                    ForEach(searchlist, id: \.self) { index in
                        NavigationLink(destination: Garagedetails(detailsview: self.garagehelper.garagelist[index])) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(garagehelper.garagelist[index].name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("darkgray"))
                                    .font(.system(size: 22))
                                Text(garagehelper.garagelist[index].location)
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .font(.system(size: 15.5))
                                Text("Service Type: \(garagehelper.garagelist[index].availability)")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            .padding(11)
                        }
                    }
                }
                Spacer()
            }
            .onAppear() {
                self.garagehelper.fetchGaragelist()
                print(UserDefaults.standard.string(forKey: "EMAIL"))
                for i in 0..<garagehelper.garagelist.count {
                    print("type of avail \(garagehelper.garagelist[i].availability)")
                }
            }
            .searchable(text: $searchlocation)
            .autocorrectionDisabled()
        }
        .navigationBarBackButtonHidden(true)
       
    }
    
    var searchlist: [Int] {
        if searchlocation.isEmpty {
            return garagehelper.garagelist.indices.filter { typegarage(garagehelper.garagelist[$0]) }
        } else {
            return garagehelper.garagelist.indices.filter { index in
                let garage = garagehelper.garagelist[index]
                return typegarage(garage) && garage.name.localizedCaseInsensitiveContains(searchlocation)
            }
        }
    }
    
    func typegarage(_ garage: Garage) -> Bool {
        switch selectedServiceType {
        case .immediate:
            return garage.availability == "Immediate" || garage.availability == "both"
        case .advance:
            return garage.availability == "Advance" || garage.availability == "both"
        case .all:
            return true
        }
    }
}
