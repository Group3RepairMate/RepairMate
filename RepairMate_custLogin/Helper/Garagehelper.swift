
import Foundation

class Garagehelper: ObservableObject{
    @Published var garagelist = [Garage]()
    @Published var garagelistSize:Int = 1
    
    private let baseURL = "https://dark-pear-scallop-toga.cyclic.app/garages"
    
    init() {
        fetchGaragelist()
    }
    func fetchGaragelist() {
        print("fetchGaragelist start")
        guard let api = URL(string: baseURL) else{
            print(#function, "Unable to convert string to url method")
            return
        }

        let task = URLSession.shared.dataTask(with: api){ (data : Data?, response : URLResponse?, error : Error?) in
            
            if let error = error{
                print(#function, "Error connecting \(error)")
            }
            else{
                if let httpResponse = response as? HTTPURLResponse{
                    if (httpResponse.statusCode == 200){
                        DispatchQueue.global().async {
                            do{
                                if (data != nil){
                                    if let jsonData = data{
                                        let jsonDecoder = JSONDecoder()
                                        var garages = try jsonDecoder.decode(Garagesstruct.self, from: jsonData)
                                        
                                        DispatchQueue.main.async {
                                            self.garagelist = garages.list
                                        }
                                        print("fetchGaragelist garagelist --> \(self.garagelist)")
                                    }
                                    else{
                                        print(#function, "Unable to get the JSON")
                                    }
                                }
                                else{
                                    print(#function, "Response received without data")
                                }
                            }
                            catch let error{
                                print(#function, "Error while extracting : \(error)")
                            }
                        }
                    }
                    else{
                        print(#function, "Unsuccessful response. Response : \(httpResponse.statusCode)")
                    }
                }
                else{
                    print(#function, "Unable to get HTTP Response")
                }
            }
            print("fetchGaragelist end")
        }
        task.resume()
    }
}

