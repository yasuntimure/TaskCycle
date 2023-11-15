//
//  WeekSliderView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-10.
//

import SwiftUI

struct WeekSliderView: View {
    @EnvironmentObject var theme: Theme

    @EnvironmentObject var vm: DailyViewModel

    var body: some View {
        TabView(selection: $vm.weekIndex) {
            ForEach(vm.weeks.indices, id: \.self) { index in
                let week = vm.weeks[index]
                WeekView(week)
                    .padding(.horizontal, 15)
                    .tag(index)
            }
        }
        .onChange(of: vm.weekIndex) { newValue in
            /// Creating When it reaches first/last Page
            vm.createWeek = (newValue == 0 || newValue == (vm.weeks.count - 1))
        }
        .onAppear { vm.setWeekData() }
    }


    /// Week View
    @ViewBuilder
    func WeekView(_ week: [WeekDay]) -> some View {
        HStack(spacing: 10) {
            ForEach(week) { day in
                WeekColumn(date: day.date, isSelected: vm.isSelected(day))
                    .hSpacing(.center)
                    .onTapGesture {
                        /// Updating Selected Day
                        withAnimation {
                            hideKeyboard()
                            vm.selectedDay = day
                            vm.fetchItems()
                            print("Selected Day: ",day.date.weekdayFormat())
                        }
                    }
            }
            .background {
                GeometryReader {
                    let minX = $0.frame(in: .global).minX

                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self) { value in
                            /// When the Offset reaches 15 and if the createWeek is toggled then simply generating next set of week
                            if value.rounded() == 15 && vm.createWeek {
                                withAnimation {
                                    vm.paginateWeek()
                                    vm.createWeek = false
                                }
                            }
                        }
                }
            }
        }
    }

    @ViewBuilder
    func WeekColumn(date: Date, isSelected: Bool) -> some View {
        VStack (spacing: 8) {
            Text(date.format("E"))
                .font(.callout).fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .gray)

            Text(date.format("dd"))
                .font(.callout).fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .gray)
                .frame(width: 35, height: 35)
                .overlay(
                    Circle()
                        .stroke(lineWidth: isSelected ? 2 : 1)
                        .foregroundColor(isSelected ? .white : .gray)
                )
        }
        // MARK: Foreground Style
        .foregroundStyle(date.isToday ? .primary : .secondary)
        .foregroundColor(date.isToday ? .white : .black)
        // MARK: Capsule Shape
        .frame(width: 45, height: 90)
        .background(
            ZStack{
                // MARK: Matched Geometry Effect
                if isSelected {
                    Capsule()
                        .fill(theme.mTintColor)
                        .layeredBackground(theme.mTintColor, cornerRadius: 24)
                }

                /// Indicator to Show Today's Date
                if date.isToday {
                    Capsule()
                        .stroke(lineWidth: 2)
                        .foregroundColor(theme.mTintColor).opacity(0.6)
                }
            }
        )
        .contentShape(Capsule())

    }

}

struct WeekSliderView_Previews: PreviewProvider {
    static var previews: some View {
        WeekSliderView()
            .environmentObject(DailyViewModel())
            .environmentObject(Theme())
    }
}
