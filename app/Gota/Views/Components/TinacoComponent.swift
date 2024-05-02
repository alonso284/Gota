//
//  TinacoComponent.swift
//  Gota
//
//  Created by Alumno on 10/03/24.
//

import SwiftUI

struct TinacoComponent: View {
    var TinacoNumber: String
    var Percentage: Int

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.quinary.opacity(0.4))
                    .frame(minHeight: 0, maxHeight: .infinity)

                VStack(alignment: .center) {
                    Text(TinacoNumber)
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundStyle(.secondary)

                    Text("\(Percentage)%")
                        .bold()
                        .font(.system(size: 50))
                }.padding()

                
            }.frame(width: 160,height: 160)
        }
    }
}

#Preview {
    TinacoComponent(TinacoNumber: "Tinaco 02", Percentage: 30)
}
