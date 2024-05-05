import SwiftUI

struct ControlFlujoView: View {
    @State private var valvePressure: Double = 1.96
    @State private var isValveOn: Bool = false
    @State private var isEditing = false
    @State private var zonaValue = 1
    
    @StateObject var valve = ValveController()
    
    var body: some View {
        HStack(spacing:0){
            HStack {
                Form {
                    Section(header: Text("Zona")) {
                        Picker("Seleccione la zona", selection: $zonaValue) {
                            Text("General").tag(1)
                            Text("Torre 1").tag(2)
                            Text("Torre 2").tag(3)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    
                    Section(header:Text("Nivel de presión")){
                        ZStack(alignment: .topLeading){
                            VStack(alignment: .leading){
                                Text("\(String(format:"%.2f", $valvePressure.wrappedValue)) kg/cm²").font(.system(size: 40)).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                                Slider(value: $valvePressure, in: 0...6) { editing in
                                    isEditing = editing
                                    
                                }
                            }
                        }.padding(.vertical)
                       
                        
                    }
                }
                .padding(0)
                .scrollDisabled(true)
                    
                
                Form {
                    Section(header: Text("Visualización de tubería")) {
                        Image("GotaPlanDeAhorro")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 800, height: 280)
                            .padding(.vertical)
                    }
                    
                    Section(header: Text("Detalles de tubería")) {
                        DetailView(title: "Fecha de último mantenimiento", value: "2024-02-18")
                        DetailView(title: "Fecha de instalación", value: "2024-01-01")
                        DetailView(title: "Material", value: "Cobre")
                      
                        DetailView(title: "Prioridad", value: "1")
                    }
                }
                .scrollDisabled(true)
            }
            .navigationTitle("Control de Flujo")
        }
        .background(Color("systemBackground"))
    }
}

struct DetailView: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .bold()
            Spacer()
            Text(value)
        }
        .padding(.vertical)
    }
}

struct PlanDeAhorroView_Previews: PreviewProvider {
    static var previews: some View {
        ControlFlujoView()
    }
}
