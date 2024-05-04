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
                // Background Image
                Image("waterbody")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all) // Ignore safe area to cover the entire screen with the image
                    .cornerRadius(15)
                    .shadow(radius: 4)

                // Semi-transparent gray overlay
                Color.black.opacity(0.2)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                // Content VStack
                VStack(alignment: .center) {
                    Spacer()
                    Text("\(Percentage)%")
                        .fontWeight(.heavy)
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                    Spacer()
                    Text(TinacoNumber)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding()
            }
            .frame(width: 170, height: 170)
        }

    }
}

#Preview {
    TinacoComponent(TinacoNumber: "Tinaco 02", Percentage: 30)
}
