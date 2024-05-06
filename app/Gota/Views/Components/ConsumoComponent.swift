//
//  ConsumoComponent.swift
//  Gota
//
//  Created by Sofia Sandoval on 5/2/24.
//


import Charts
import SwiftUI

struct ConsumoComponent: View {
    @ObservedObject var viewModel: SubZoneViewModel

    // Function to get color based on zone_id
    func colorForZone(_ zoneId: String) -> Color {
        switch zoneId {
        case "G1":
            return Color.teal.opacity(0.8) // Darker teal for "General"
        case "T1":
            return Color.teal.opacity(0.6) // Medium teal for "Torre 1"
        case "T2":
            return Color.teal.opacity(0.4) // Lighter teal for "Torre 2"
        default:
            return Color.teal.opacity(0.2) // Default teal for any other IDs
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Consumo por zona")
                .font(.title2)
            Text("(30 días)")
            ZStack {
                Chart(viewModel.subzones, id: \.self.name) { subzone in
                    SectorMark(
                        angle: .value("Value", subzone.total_input_volume),
                        innerRadius: .ratio(0.618),
                        outerRadius: .inset(10),
                        angularInset: 1
                    )
                    .cornerRadius(4)
                    .foregroundStyle(colorForZone(subzone.zone_id)) // Apply custom teal colors based on zone_id
                }
                Text("\(Int(self.viewModel.total / 1000)) kL")
                    .font(.system(size: 15))
                    .padding(.bottom)
            }
        }
        .padding()
        .frame(width: 300, height: 320)
    }
}
