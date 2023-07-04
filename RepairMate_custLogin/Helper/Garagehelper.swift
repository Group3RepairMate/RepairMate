
import Foundation

class Garagehelper: ObservableObject{
    @Published var garagelist = [Garage]()
    @Published var garagelistSize:Int = 1
    
    private let baseURL = "http://localhost:8080/garages"
    
    init() {
        fetchGaragelist()
    }
    func fetchGaragelist() {
        guard let api = URL(string: baseURL) else{
            print(#function, "Unable to convert string to URL")
            return
        }

        let task = URLSession.shared.dataTask(with: api){ (data : Data?, response : URLResponse?, error : Error?) in
            
            if let error = error{
                print(#function, "Error while connecting to network \(error)")
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
                                    }
                                    else{
                                        print(#function, "Unable to get the JSON data")
                                    }
                                }
                                else{
                                    print(#function, "Response received without data")
                                }
                            }
                            catch let error{
                                print(#function, "Error while extracting data : \(error)")
                            }
                        }
                    }
                    else{
                        print(#function, "Unsuccessful response. Response Code : \(httpResponse.statusCode)")
                    }
                }
                else{
                    print(#function, "Unable to get HTTP Response")
                }
            }
        }
        task.resume()
    }
}

