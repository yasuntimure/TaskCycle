//
//  WeekColumn.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-10.
//

import SwiftUI

struct WeekColumn: View {

    @State var date: Date
    @State var isSelected: Bool

    var body: some View {
        VStack (spacing: 8) {
            Text(date.format("E"))
                .font(.callout).fontWeight(.medium)
                .foregroundColor(.gray)

            Text(date.format("dd"))
                .font(.callout).fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .gray)
                .frame(width: 35, height: 35)
                .overlay(
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                        .shadow(radius: 1).opacity(0.5)
                )
                .background {
                    BackgrounView(date)
                }

        }
    }

    @ViewBuilder
    private func BackgrounView(_ date: Date) -> some View {
        if isSelected {
            Circle()
                .fill(Color.darkBlue)
        }

        /// Indicator to Show Today's Date
        if date.isToday {
            Circle()
                .fill(.cyan)
                .frame(width: 5, height: 5)
                .vSpacing(.bottom)
                .offset(y: 12)
        }
    }
}

struct WeekColumn_Previews: PreviewProvider {
    static var previews: some View {
        WeekColumn(date: Date(), isSelected: false)
    }
}
