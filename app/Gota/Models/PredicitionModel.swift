//
//  File.swift
//  Gota
//
//  Created by Alumno on 09/03/24.
//

import Foundation
import CoreML

struct SensorData: Codable {
    let average_vibration: Double
    let diameter: Double
    let length: Double
    let material: String
    let sensor_id: String
    let subzone: String?
    let subzone_id: String?
    let thickness: Double
    let zone: String?
    let zone_id: String?
    
    var category:String {
        do {
            let config = MLModelConfiguration()
            let model = try PredictorDeFugas(configuration: config)
            
            let prediction = try model.prediction(diameter: self.diameter, length: self.length, thickness: self.thickness, material: self.material, frequency: self.average_vibration)
            
            
            return prediction.leaking
        }
        catch {
            return "Loading"
        }
    }
}
