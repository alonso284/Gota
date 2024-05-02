//
//  Principal.swift
//  Gota
//
//  Created by Alumno on 09/03/24.
//

import Foundation

// Define the struct matching the JSON structure
struct Subzone: Codable {
    let leaked: Double
    let name: String
    let subzone_id: String
    let total_input_volume: Double
    let total_output_volume: Double
    let zone_id: String
}

struct DayLog: Codable {
    let date: Date
    let type: String
    let value: Double
}

struct Consumed: Codable {
    let consumed: Double
    let leaked: Double
}
