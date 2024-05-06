//
//  ContentView.swift
//  Gota
//
//  Created by Alumno on 09/03/24.
//

import SwiftUI
import SwiftData


enum NavigationDestination {
    case alertas
    case planDeAhorro
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                PrincipalView()
                    .navigationTitle("Dashboard")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem { Label("Dashboard", systemImage: "chart.pie") }
            
            NavigationView {
                PlanDeAhorroView()
                    .navigationTitle("Control de Flujo")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem { Label("Control de Flujo", systemImage: "pipe.and.drop.fill") }
            
            NavigationView {
                ControlFlujoView()
                    .navigationTitle("Plan de Ahorro")
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem { Label("Plan de Ahorro", systemImage: "spigot") }
        }
    }
}

#Preview {
    ContentView()
}
