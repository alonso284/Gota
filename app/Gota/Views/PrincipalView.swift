//
//  Principal.swift
//  Gota
//
//  Created by Alumno on 09/03/24.
//

import SwiftUI
import Charts

let cost_per_liter = 0.00089

struct PrincipalView: View {
    @StateObject private var viewModel = SubZoneViewModel()
    
    let data = [
        (name: "Cachapa", sales: 9631),
        (name: "Crêpe", sales: 6959),
        (name: "Injera", sales: 4891),
        (name: "Jian Bing", sales: 2506),
        (name: "American", sales: 1777),
        (name: "Dosa", sales: 625),
    ]
    var body: some View {
            VStack {
                HStack {
                    //
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 20).fill(.quinary.opacity(0.4))
                        VStack(alignment: .leading){
                            Spacer()
                            Spacer()
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Periodo")
                                        .font(.largeTitle)
                                    Text(String(format: "$%.2f", viewModel.total * cost_per_liter))
                                        .font(.title)
                                }
                                Spacer()
                                Image("logo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 17.18 * 3.6, height: 20.92 * 3.6)
                                    .padding(.trailing)
                            }
                            Spacer()
                            Spacer()
                            Divider()
                            Spacer()
                            Spacer()
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Aumento")
                                        .font(.title)
                                    Text(String(format: "-$%.2f", viewModel.total * cost_per_liter * 0.2))
                                        .foregroundStyle(Color.green)
                                }
                                Spacer()
                                Text("-2%")
                                    .font(.title)
                                    .foregroundStyle(Color.green)
                                
                            }
                            Spacer()
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Gasto por fugas")
                                        .font(.title)
                                    Text(String(format: "$%.2f", viewModel.leaked * cost_per_liter))
                                }
                                Spacer()
                                Text(String(format: "%.2f%%", viewModel.leaked / (viewModel.total == 0 ? 1 : viewModel.total )))
                                    .font(.title)
                                    .foregroundStyle(Color.red)
                                
                            }
                            Spacer()
                            Spacer()
                        }
                        .padding(.vertical)
                        .padding()
                        
                        
                    }
                    .frame(width: 350)
                    .padding()
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 20).fill(.quinary.opacity(0.4))
                        VStack {
                            Spacer()
                            HStack {
                                Group {
                                    Text("Fugas detectadas")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                }
                                .font(.largeTitle)
    //                            .foregroundStyle(Color.red)
                            }
                            Spacer()
                            Spacer()
                            Divider()
                            Spacer()
                            Spacer()
                            HStack {
                                Group {
                                    Text("Mayores")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                }
                                .font(.title)
                                .foregroundStyle(Color.red)
                            }
                            Spacer()
                            HStack {
                                Group {
                                    Text("Mayores")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                }
                                .font(.title)
                                .foregroundStyle(Color.orange)
                            }
                            
                            Spacer()
                            HStack {
                                Group {
                                    Text("Mayores")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                }
                                .font(.title)
                                .foregroundStyle(Color.green)
                            }
                                
                        }
                        .padding()
                        .padding()
                        
                    }
                    .padding()
                    
                    VStack {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(.quinary.opacity(0.4))
                            VStack(alignment: .leading){
                                HStack {
                                    Circle().fill(.yellow).frame(height: 15)
                                    Text("Sequía Detectada").fontWeight(.medium)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                Text("Efectuar Plan de ahorro").padding(.leading,20)
                                Text("Haz click aquí para notificar inquilinos. \nActiva plan de ahorro desde GOTA para iPad.").foregroundStyle(.secondary).font(.system(size: 16))
                                    .padding(.leading, 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .allowsTightening(true)
                                    .lineLimit(3)
                                    .fixedSize(horizontal: false, vertical: true)
                            }.padding()
                            
                        }
                        .padding(.bottom)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).fill(.quinary.opacity(0.4))
                            VStack(alignment: .leading){
                                HStack {
                                    Circle().fill(.yellow).frame(height: 15)
                                    Text("Sequía Detectada").fontWeight(.medium)
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                Text("Efectuar Plan de ahorro").padding(.leading,20)
                                Text("Haz click aquí para notificar inquilinos. \nActiva plan de ahorro desde GOTA para iPad.").foregroundStyle(.secondary).font(.system(size: 16))
                                    .padding(.leading, 20)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .allowsTightening(true)
                                    .lineLimit(3)
                                    .fixedSize(horizontal: false, vertical: true)
                            }.padding()
                            
                        }
                        .padding(.bottom)
                    }
                    .frame(width: 400,height: 350)
                    
                    
                }
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(.quinary.opacity(0.4))
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
                    }
                    .frame(width: 300,height: 320)
                    .padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 20).fill(.quinary.opacity(0.4))
                        VStack(alignment: .leading) {
                            Text("Consumo en últimos 7 días")
                                .font(.title)
                            ZStack {
                                Chart(self.viewModel.days, id: \.self.date) {
                                    day in
                                    AreaMark(
                                        x: .value("Day", day.date),
                                        y: .value("Liters", Int(day.value)%100)
                                    )
                                    .foregroundStyle(by: .value("Type", day.type))
                                }
                            }
                            
                        }
                        
                        
                        .padding()
                    }
    //                .frame(width: 100)
                    .padding()
                    
                    
                }
                .frame(height: 350)
            }
            .padding()
            .onAppear {
                print("loading")
                viewModel.fetchSubZoneData()
                viewModel.fetchDays()
        }

    
    }
    

}

#Preview {
    PrincipalView()
}
