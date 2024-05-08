//
//  GotaComponent.swift
//  Gota
//
//  Created by Sofia Sandoval on 5/7/24.
//

import SwiftUI

struct GotaComponent: View {
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
                    .cornerRadius(15)
                
                // Content VStack
                VStack(alignment: .center) {
                    Spacer()
                    Image(systemName:"drop.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
            }
            .frame(width:250, height: 130)
        }
        .padding(EdgeInsets(top: 20,leading: 0, bottom: 0, trailing: 0))
       

    }
}

#Preview {
    ContentView()
}
