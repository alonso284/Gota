//
//  Item.swift
//  scanner
//
//  Created by Alonso Huerta on 05/05/24.
//

import Foundation

// Define a struct to represent the data
struct PipeData: Codable {
    let diameter: Int
    let flow_meter_tuple: Bool
    let length: Int
    let material: String
    let pipe_id: String
    let priority: String?
    let revision_date: String?
    let subzone: String?
    let thickness: Double
    let valve: Bool
    let vibrator: Bool
    let zone: String?
}

// Define a class to handle fetching and parsing of data
class PipeDataManager {
    
    // Method to fetch data from the provided URL and initialize PipeData instance
    func fetchPipeData(serialId: String, completion: @escaping (PipeData?) -> Void) {
        
        // Define the URL string with the provided serial ID
        let urlString = "http://137.184.90.155:5000/serial/\(serialId)"
        
        // Create a URL object from the string
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Create a URLSession task to fetch the data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            // Check if there is data
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                // Try to decode the received JSON data into PipeData
                let decoder = JSONDecoder()
                let pipeData = try decoder.decode(PipeData.self, from: data)
                
                // Call the completion handler with the fetched data
                completion(pipeData)
                
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        
        // Start the URLSession task
        task.resume()
    }
}
