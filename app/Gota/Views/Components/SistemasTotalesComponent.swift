//
//  SistemasTotalesComponent.swift
//  Gota
//
//  Created by felipe ivan on 04/05/24.
//

import SwiftUI

struct SistemasTotalesComponent: View {
    var body: some View {
        HStack{
            Text("Zonas totales").font(.title3)
            Spacer()
            Text("2").foregroundStyle(Color.accentColor)
        }
    }
}

#Preview {
    SistemasTotalesComponent()
}
