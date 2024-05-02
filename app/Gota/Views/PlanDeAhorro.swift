//
//  PlanDeAhorro.swift
//  Gota
//
//  Created by Alumno on 10/03/24.
//

import SwiftUI

struct PlanDeAhorro: View {
    @State private var speed = 50.0
    @State private var spee2 = 50.0
    @State private var isEditing = false
    @StateObject private var viewModel = PredicionViewModel()

    var body: some View {
        HStack {
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.quinary.opacity(0.4))
                    
                    VStack(alignment: .leading) {
                        Text("Control de zonas para hoy")
                            .font(.title)
                            .bold()
                            .padding(.vertical)

                        Text("Basado en el consumo de las zonas de Nuevo Norte, es recomendable dejar en los niveles sugeridos para una mejor experiencia. Podrás efectuar cambios \ndesde esta interfaz.")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding([.bottom])
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack {
                            Text("Zona 1")
                                .fontWeight(.light)
                            Slider(value: $speed, in: 0...100) { editing in
                                isEditing = editing
                            }
                        }
                        .padding(.vertical)

                        HStack {
                            Text("Zona 2")
                                .fontWeight(.light)
                            Slider(value: $spee2, in: 0...100) { editing in
                                isEditing = editing
                            }
                        }
                        .padding(.bottom)

                        HStack {
                            Spacer()
                            Button("Guardar cambios") {}
                                .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                }

                VStack (alignment: .leading){
                    Text("Niveles del agua")
                        .font(.title)
                        .bold()
                        .padding(.vertical)
                    HStack(spacing: 30){
                        TinacoComponent(TinacoNumber: "Tinaco 01", Percentage: 30)
                        
                        TinacoComponent(TinacoNumber: "Tinaco 01", Percentage: 30)
                        TinacoComponent(TinacoNumber: "Tinaco 01", Percentage: 30)
                        TinacoComponent(TinacoNumber: "Tinaco 01", Percentage: 30)
                    }
                    
                }.frame(height: 300)
            }

            ZStack(alignment:.topLeading) {
                RoundedRectangle(cornerRadius: 20)
                .fill(.quinary.opacity(0.4))
                VStack{
                    Text("Notificaciones")
                        .font(.title)
                        .bold()
                        .padding(.vertical)
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
            }.frame(width: 400)
        }
    }
}

#Preview {
    PlanDeAhorro()
}
