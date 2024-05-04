//
//  SequiaNotifComponent.swift
//  Gota
//
//  Created by Sofia Sandoval on 5/2/24.
//

import SwiftUI

struct SequiaNotifComponent: View {
    // crear view model para diff colorcito de status osea rojo urgente, y asi
    var body: some View {
        VStack {
            ZStack{
                VStack(alignment: .leading){
                    HStack {
                        Circle().fill(.yellow).frame(height: 12)
                        Text("Sequía Detectada").fontWeight(.medium)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Text("Efectuar Plan de ahorro").padding(.leading,20)
                    Text("Haz click aquí para notificar inquilinos. \nActiva plan de ahorro desde GOTA para iPad.").foregroundStyle(.secondary).font(.system(size: 16))
                        .padding(.leading, 17)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .allowsTightening(true)
                        .lineLimit(3)
                }.padding()
            }
            .frame(width: 380,height: 140)
            .padding(.bottom)
        }
    }
}

#Preview {
    SequiaNotifComponent()
}
