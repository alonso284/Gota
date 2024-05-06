//
//  WeeklyUseComponent.swift
//  Gota
//
//  Created by Sofia Sandoval on 5/5/24.
//
import Charts
import SwiftUI

struct WeeklyUseComponent: View {
    @ObservedObject var viewModel: SubZoneViewModel
    var body: some View {
        Text("Consumo en últimos 7 días")
            .font(.title2)
        ZStack {
            Chart(self.viewModel.days, id: \.self.date) {
                day in
                AreaMark(
                    x: .value("Day", day.date),
                    y: .value("Liters", Int(day.value)%100)
                )
                .foregroundStyle(by: .value("Type", day.type))
            }
        }
        .frame(width: 600,height: 280)
    }
}

