import Foundation

class PredicionViewModel: ObservableObject {
//    @Published var subzones: [Subzone] = [Subzone(leaked: 5, name: "P1", subzone_id: "P1", total_input_volume: 5, total_output_volume: 5, zone_id: "T1")]
//    @Published var total = 0.0
//    @Published var leaked = 0.0
//    @Published var nleaks = 0
//    @Published var days: [DayLog] = []
    
    @Published var sensorData:[SensorData] = []
    
    func fetchSensorData() {
        guard let url = URL(string:  url + "/vibration") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([SensorData].self, from: data) {
                    DispatchQueue.main.async {
//                        self.sensorData = decodedResponse.sorted(by: { sensor1, sensor2 in
//                            if sensor1.zone ?? "" == sensor2.zone ?? "" {
//                                return sensor1.subzone ?? "" < sensor2.subzone ?? ""
//                            }
//                            return sensor1.zone ?? "" < sensor2.zone ?? ""
//                        })
                        self.sensorData = decodedResponse.sorted(by: { sensor1, sensor2 in
                            return sensor1.category > sensor2.category
                        })
                        print(self.sensorData)
                        
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}
