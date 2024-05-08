//
//  PlanDeAhorro.swift
//  Gota
//
//  Created by Alumno on 10/03/24.
//

import SwiftUI

struct PlanDeAhorroView: View {
    @State private var valvePressure1: Double = 1.96
    @State private var valvePressure2: Double = 1.96
    @State private var isEditing = false
    @StateObject private var viewModel = PredicionViewModel()

    var body: some View {
        HStack {
            VStack {
                Form {
                    Section(header:Text("Control de Flujo")){
                        VStack(alignment:.leading) {
                            Text("Zona 1")
                                .font(.title3)
                                .bold()
                                .padding(.leading)
                            HStack {
                                
                                VStack {
                                    Text("\(String(format:"%.2f", $valvePressure1.wrappedValue)) kg/cm²").font(.system(size: 20)).frame(maxWidth: 170, alignment: .trailing)
                                    Slider(value: $valvePressure1, in: 0...6) { editing in
                                        isEditing = editing
                                        
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        VStack(alignment:.leading) {
                            Text("Zona 2")
                                .font(.title3)
                                .bold()
                                .padding(.leading)
                            HStack {
                                
                                VStack {
                                    Text("\(String(format:"%.2f", $valvePressure2.wrappedValue)) kg/cm²").font(.system(size: 20)).frame(maxWidth: 170, alignment: .trailing)
                                    Slider(value: $valvePressure2, in: 0...6) { editing in
                                        isEditing = editing
                                        
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                           
                        

                    }
                                        
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 0))
                .scrollDisabled(true)

                VStack (alignment: .leading){
                    Text("Niveles del agua")
                        .font(.title2)
                        .bold()
                        .padding(.vertical)
               
    
                       
                    HStack(spacing: 20){
                        TinacoComponent(TinacoNumber: "Tinaco 01", Percentage: 30)
                        TinacoComponent(TinacoNumber: "Tinaco 02", Percentage: 50)
                        TinacoComponent(TinacoNumber: "Tinaco 03", Percentage: 60)
                        TinacoComponent(TinacoNumber: "Tinaco 04", Percentage: 90)
                    }                    
                }
                .frame(height: 300)
  
                    
            }

           Form {
                Section(header:Text("Notificaciones")){
                    List {
                        ForEach(viewModel.sensorData.filter { $0.category == "slow" }, id: \.sensor_id) { sensor in
                            VStack (alignment: .leading){
                                Text("Fuga Detectada ").bold()
                                Text("\(sensor.zone ?? "NaN") \(sensor.subzone ?? "NaN")")
                                Text("Haz click aquí para cerrar válvula, y notificar a inquilinos.").foregroundStyle(.secondary)
                            }
                            
                        }
                    }.listStyle(.automatic)
                    .onAppear {
                        print("loading sensor")
                        viewModel.fetchSensorData()
                    }.scrollContentBackground(.hidden)

                }.padding()
            }
           .frame(width: 400)
        }
        .navigationTitle("Plan de Ahorro")
        .background(Color("systemBackgroundGota"))
    }
}

#Preview {
    ContentView()
}
