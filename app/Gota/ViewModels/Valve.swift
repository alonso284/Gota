import Foundation

let device_address = "http://192.168.3.31"

class ValveController: ObservableObject {
    @Published var closed = true
    
    
    func openValve() {
        guard let url = URL(string:  device_address + "/openValve") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                self.closed = false
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func closeValve() {
        guard let url = URL(string:  device_address + "/closeValve") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                print(data)
                self.closed = true
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}