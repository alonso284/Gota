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
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                HStack {
                    VStack(alignment: .leading){
                        Form{
                            Section{
                                HStack {
                                    Text("Periodo")
                                        .font(.title2)
                                    Spacer()
                                    Text(String(format: "$%.2f", viewModel.total * cost_per_liter))
                                        .font(.title2)
                                }
                                .padding()
                            }
                            Section{
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Aumento")
                                            .font(.title3)
                                        Text(String(format: "-$%.2f", viewModel.total * cost_per_liter * 0.2))
                                            .foregroundStyle(Color.green)
                                    }
                                    Spacer()
                                    Text("-2%")
                                        .font(.title3)
                                        .foregroundStyle(Color.green)
                                }
                                .padding(.horizontal)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Gasto por fugas")
                                            .font(.title3)
                                        
                                        Text(String(format: "$%.2f", viewModel.leaked * cost_per_liter))
                                            .foregroundStyle(Color.red)
                                    }
                                    Spacer()
                                    Text(String(format: "%.2f%%", viewModel.leaked / (viewModel.total == 0 ? 1 : viewModel.total )))
                                        .font(.title3)
                                        .foregroundStyle(Color.red)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .scrollDisabled(true)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                        .padding(.top)
                       
                    }
                    .frame(width: 400,height:400)
                  
                    VStack {
                        Form {
                            Section{
                                HStack {
                                    Text("Fugas Detectadas")
                                        .font(.title2)
                                    Spacer()
                                    Text(String(format:"%.2f%",viewModel.nleaks))
                                        .font(.title2)
                                }
                                .padding()
                                
                                
                            }
                          
                            Section{
                                HStack {
                                    Text("Alta Prioridad")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                        .foregroundStyle(Color.red)
                                }
                                HStack {
                                    Text("Media Prioridad")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                        .foregroundStyle(Color.orange)
                                }
                                HStack {
                                    Text("Baja Prioridad")
                                    Spacer()
                                    Text("\(viewModel.nleaks)")
                                        .bold()
                                        .foregroundStyle(Color.green)
                                }
                            }
                            
      
                        }
                        .scrollDisabled(true)
                        
                        
                        
                    }
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .frame(width: 500,height:380)
                   
                    Form{
                        Section{
                            SistemasTotalesComponent()
                            GotasTotales()
                        }
                    }
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    
                    
                    
                    .scrollDisabled(true)
                    .frame(height:220)
                }
                

                
                HStack {
                   // viewmodel is being sent to consumo component made
                    VStack{
                        Form{
                            ConsumoComponent(viewModel: viewModel)
                        }
                        .scrollDisabled(true)
                    }.frame(width:400,height:480)
                   
                  
                    VStack(alignment: .leading) {
                        Form{
                            WeeklyUseComponent(viewModel: viewModel)
                        }
                        .scrollDisabled(true)
                    }
                    .frame(height: 480)
                    
                }
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
            }
            .padding()
            .onAppear {
                print("loading")
                viewModel.fetchSubZoneData()
                viewModel.fetchDays()
            }
        
        .navigationTitle("Dashboard")
        .background(Color("systemBackgroundGota"))
    }
}

#Preview {
    ContentView()
}

