//
//  PlanDeAhorroView.swift
//  Gota
//
//  Created by Alumno on 10/03/24.
//

import SwiftUI

struct PlanDeAhorroView: View {
    @State private var valvePressure: Double = 1.96
    @State private var isValveOn: Bool = false
    @State private var isEditing = false
    
    @StateObject var valve = ValveController()
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                VStack(alignment:.leading){
                   Spacer()
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.quinary.opacity(0.4))
                            .frame(maxWidth: .infinity)
                        Text("\(Image(systemName: "chevron.right"))  Torre 1")
                            .fontWeight(.medium)
                            .padding()
                    }.frame(maxHeight: 33).padding()
                    
                    ZStack(alignment: .topLeading){
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.quinary.opacity(0.4))
                            .frame(minHeight: 0, maxHeight: .infinity)
                        VStack(alignment: .leading){
                            Text("Nivel de presión").font(.title).padding()
                            Text("\(String(format:"%.2f", $valvePressure.wrappedValue)) kg/cm²").font(.system(size: 40)).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                            Slider(value: $valvePressure, in: 0...6) { editing in
                                isEditing = editing
                                
                            }.padding()
                        }
                    }.padding()
                }
                VStack(alignment:.leading,spacing: 30){
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.quinary.opacity(0.4))
                            .frame(maxWidth: .infinity)
                        Text("\(Image(systemName: "chevron.right"))  `General")
                            .fontWeight(.medium)
                            .padding()
                    }.frame(maxHeight: 33).padding(.horizontal)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.quinary.opacity(0.4))
                            .frame(maxWidth: .infinity)
                        Text("\(Image(systemName: "chevron.right"))  Torre 2")
                            .fontWeight(.medium)
                            .padding()
                    }.frame(maxHeight: 33).padding(.horizontal)
                    Spacer()
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.quinary.opacity(0.4))
                            .frame(maxWidth: .infinity)
//                        Toggle("Valvula", isOn: $isValveOn)
//                            .onTapGesture {
//                                
//                            }
                        HStack{
                            Button("Open"){
                                valve.closeValve()
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                            Button("Close"){
                                
                                valve.openValve()
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                        }
                        .padding()
                    }.frame(maxHeight: 33).padding(.horizontal)
                    
                    
                }
            }.frame(width: 450)
            VStack(alignment:.leading,spacing: 30){
                Spacer()
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.quinary.opacity(0.4))
                    .frame(minHeight: 0, maxHeight: .infinity)
                    VStack(alignment:.leading,spacing: 60){
                        Text("Visualización de tubería")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.leading)
                        Image("GotaPlanDeAhorro").resizable().scaledToFit().frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .center)
                    }.padding()
                }.frame(maxHeight: 400).padding(.top)
                Spacer()
                ZStack{
                    
                    VStack{
                        HStack{
                            Text("Fecha de último mantenimiento")
                                .bold()
                            Spacer()
                            Text("2024-02-18")
                        }
                        Divider()
                        HStack{
                            Text("Fecha de instalación")
                                .bold()
                            Spacer()
                            Text("2024-01-01")
                        }
                        Divider()
                        HStack{
                            Text("Material")
                                .bold()
                            Spacer()
                            Text("Cobre")
                        }
                        Divider()
                        HStack{
                            Text("Prioridad")
                                .bold()
                            Spacer()
                            Text("1")
                        }
                    }
                    .padding()
                }.frame(maxHeight: 200)
            }
            
        }
        .navigationTitle("Control de Flujo")
    }
}

#Preview {
    PlanDeAhorroView()
}
