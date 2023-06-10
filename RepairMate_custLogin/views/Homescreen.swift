import SwiftUI

struct Homescreen: View {
    
    @State private var useremail:String = ""
    @State private var password:String = ""
    @State private var createaccount:Int? = nil
    @State private var homeview:Int? = nil
    @State var errormessage = false
    @State var isAlert = false
    @State private var searchlocation = ""
    @State private var searchText = ""
    @EnvironmentObject var garagehelper : Garagehelper
    
    var body: some View {
        NavigationView{
            VStack {
                
                Text("Garages List")
                    .foregroundColor(.blue)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(10)
                List {
                    ForEach(searchlist, id: \.self) { index in
                        NavigationLink(destination: Garagedetails(detailsview: self.garagehelper.garagelist[index])){
                            VStack(alignment: .leading, spacing: 8) {
                                Text(garagehelper.garagelist[index].name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Text(garagehelper.garagelist[index].location)
                                    .foregroundColor(.gray)
                                Text("Service Type:\(garagehelper.garagelist[index].availability)")
                                    .foregroundColor(.gray)
                                
                            }
                            .padding(11)
                        }
                    }
                }
                Spacer()
            }
            .onAppear(){
                self.garagehelper.fetchGaragelist()

            }
            .searchable(text: $searchlocation)
            .autocorrectionDisabled()
            .navigationBarBackButtonHidden(true)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var searchlist: [Int] {
        if searchlocation.isEmpty {
            return Array(0..<self.garagehelper.garagelist.count)
        } else {
            return self.garagehelper.garagelist.indices.filter { index in
                let slot = self.garagehelper.garagelist[index]
                return slot.name.localizedCaseInsensitiveContains(searchlocation)
            }
        }
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
