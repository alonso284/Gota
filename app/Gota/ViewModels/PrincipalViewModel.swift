import Foundation

let url = "http://137.184.90.155:5000"


class SubZoneViewModel: ObservableObject {
    @Published var subzones: [Subzone] = [Subzone(leaked: 5, name: "P1", subzone_id: "P1", total_input_volume: 5, total_output_volume: 5, zone_id: "T1")]
    @Published var total = 0.0
    @Published var leaked = 0.0
    @Published var nleaks = 0
    @Published var days: [DayLog] = []
    

    func fetchSubZoneData() {
        guard let url = URL(string:  url + "/leakage_per_subzone") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Subzone].self, from: data) {
                    DispatchQueue.main.async {
                        self.subzones = decodedResponse.sorted(by: { subzone1, subzone2 in
                            subzone1.zone_id < subzone2.zone_id
                        })
                        self.total = 0
                        self.leaked = 0
                        self.nleaks = 0
                        for subzone in self.subzones {
                            self.total += subzone.total_input_volume
                            self.total += subzone.leaked
                            if subzone.leaked > 0 {
                                self.nleaks += 1
                            }
                        }
                        
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func fetchDays() {
            let urlString = url + "/water_leakage_per_day"
            guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                
                let decoder = JSONDecoder()
                // Set the date decoding strategy to use a custom date formatter
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                if let decodedResponse = try? decoder.decode([DayLog].self, from: data) {
                    DispatchQueue.main.async {
                        self.days = decodedResponse.sorted(by: { day1, day2 in
                            day1.date < day2.date
                        })
                        print(self.days)
                        return
                    }
                }
                print("error")
                
            }.resume()
        }
    
    
}
