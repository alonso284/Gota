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
    

//    @State private var navPath: [NavigationDestination] = []
    @State var tab = 0

    var body: some View {
        NavigationStack{
            VStack {
                if tab == 0 {
                    PrincipalView()
                } else if tab == 1 {
                    PlanDeAhorroView()
                        .padding()
                } else if tab == 2 {
                    PlanDeAhorro()
                        .padding()
                }
            }.toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Dashboard"){
                        tab = 0
                    }
                    .bold(tab == 0)
                    Button("Administrador"){
                        tab = 1
                    }
                    .bold(tab == 1)
                    Button("Plan de ahorro"){
                        tab = 2
                    }
                    .bold(tab == 2)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
