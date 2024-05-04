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
    var body: some View {
        VStack(alignment: .leading) {
            Text("Consumo por zona (30 días)")
                .font(.title)
            ZStack {
                Chart(viewModel.subzones, id: \.self.name) {
                    subzone in
                    SectorMark(
                        angle: .value("Value", subzone.total_input_volume),
                        innerRadius: .ratio(0.618),
                        outerRadius: .inset(10),
                        angularInset: 1
                    )
                    .cornerRadius(4)
                    .foregroundStyle(by: .value("Product", subzone.zone_id))
                    
                }
                Text("\(Int(self.viewModel.total / 1000)) kL").font(.system(size: 15)).padding(.bottom)
            }
            
        }
        .padding()
        .frame(width: 300,height: 320)
    }
}

