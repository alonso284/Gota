//
//  ContentView.swift
//  scanner
//
//  Created by Alonso Huerta on 05/05/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var id:String?
    @State private var pipeData: PipeData?
    @State private var loading = false
    @State private var errorMessage = String()
    let pipeDataManager = PipeDataManager()
    
    var body: some View {
        VStack {
            if let pipeData = self.pipeData {
                Image("pipe") // Replace "pipe" with the name of your pipe image asset
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(height: 200)
               
               VStack(alignment: .leading, spacing: 10) {
                   Text("Pipe ID: \(pipeData.pipe_id)")
                       .font(.title)
                       .fontWeight(.bold)
                   
                   Divider()
                   
                   HStack {
                       Text("Diameter:")
                       Spacer()
                       Text("\(pipeData.diameter * 10) mm")
                   }
                   
                   HStack {
                       Text("Length:")
                       Spacer()
                       Text("\(pipeData.length) m")
                   }
                   
                   HStack {
                       Text("Material:")
                       Spacer()
                       Text(pipeData.material)
                   }
                   
                   HStack {
                       Text("Thickness:")
                       Spacer()
                       Text(String(format: "%.2f mm", Double(pipeData.thickness) * 10))
                   }
                   
                   HStack {
                       Text("Flow Meter:")
                       Spacer()
                       Text(pipeData.flow_meter_tuple ? "Yes" : "No")
                   }
                   
                   HStack {
                       Text("Valve:")
                       Spacer()
                       Text(pipeData.valve ? "Yes" : "No")
                   }
                   
                   HStack {
                       Text("Vibrator:")
                       Spacer()
                       Text(pipeData.vibrator ? "Yes" : "No")
                   }
                   
                   if let priority = pipeData.priority {
                       HStack {
                           Text("Priority:")
                           Spacer()
                           Text(priority)
                       }
                   }
                   
                   if let revisionDate = pipeData.revision_date {
                       HStack {
                           Text("Revision Date:")
                           Spacer()
                           Text(revisionDate)
                       }
                   }
                   
                   if let subzone = pipeData.subzone {
                       HStack {
                           Text("Subzone:")
                           Spacer()
                           Text(subzone)
                       }
                   }
                   
                   if let zone = pipeData.zone {
                       HStack {
                           Text("Zone:")
                           Spacer()
                           Text(zone)
                       }
                   }
                   
                   Spacer()
               }
               .padding()
               
               Spacer()
            } else {
                if (loading) {
                    ProgressView()
                } else {
                    Image(systemName: "globe")
                }
            }
        }
        .onOpenURL(perform: { url in
            if let id = url.host {
                self.id = id
                print("ID detected: \(id)")
            } else {
                print("No ID found")
            }
        })
        .onChange(of: self.id, loadPipeData)
        .onAppear(perform: loadPipeData)
    }
    
    func loadPipeData(){
        self.loading = true
        if let id = self.id {
            pipeDataManager.fetchPipeData(serialId: id) { pipeData in
                if let pipeData = pipeData {
                    print("Fetched Pipe Data:")
                    print(pipeData)
                    self.pipeData = pipeData
                } else {
                    print("Failed to fetch Pipe Data")
                    self.errorMessage = "Failed to fetch Pipe Data"
                }
            }
        }
        self.loading = false
    }
}

struct Sample: View {
    @State private var id: String? = nil
    var body: some View {
        ContentView(id: $id)
    }
}

#Preview {
    Sample()
}
