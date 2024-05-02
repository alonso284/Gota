//
//  SwiftUIView.swift
//  Gota
//
//  Created by Alumno on 09/03/24.
//

import SwiftUI

struct PredictionView: View {
    @StateObject private var viewModel = PredicionViewModel()
    var body: some View {
            List {
                Text("Length: \(viewModel.sensorData.count)")
                ForEach(viewModel.sensorData, id:\.self.sensor_id){
                    sensor in
                    Text(sensor.category)
                }
            }
            .onAppear {
                print("loading sensor")
                viewModel.fetchSensorData()
            }
        
        
    }
}

#Preview {
    PredictionView()
}
