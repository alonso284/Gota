//
//  Principal.swift
//  Gota
//
//  Created by Sofia Sandoval on 5/2/24.
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
        ZStack {
            VStack {
                HStack {
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
                    .frame(width: 350)
                    .padding()
                    
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
                    
                    
                   
               
                    VStack {
                        SistemasTotalesComponent()
                        GotasTotales()
                    }
                   
                    .padding(.top)
                    .padding(.top)
                    .cornerRadius(21)
                    .padding(.horizontal,60)
                }
                

                
                HStack {
                   // viewmodel is being sent to consumo component made
                    ConsumoComponent(viewModel: viewModel)
                    
                    // fix this so i actually can visualize it
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
        }.navigationTitle("Dashboard")
    }
}

#Preview {
    PrincipalView()
}
