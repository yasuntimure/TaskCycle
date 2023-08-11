//
//  WeekSliderView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-10.
//

import SwiftUI

struct WeekSliderView<VM>: View where VM: WeekSliderViewModelProtocol {

    @ObservedObject var viewModel: VM

    var body: some View {
        TabView(selection: $viewModel.weekIndex) {
            ForEach(viewModel.weeks.indices, id: \.self) { index in
                let week = viewModel.weeks[index]
                WeekView(week)
                    .padding(.horizontal, 15)
                    .tag(index)
            }
        }
        .onChange(of: viewModel.weekIndex) { newValue in
            /// Creating When it reaches first/last Page
            if newValue == 0 || newValue == (viewModel.weeks.count - 1) {
                viewModel.createWeek = true
            }
        }
        .onAppear { viewModel.setWeekData() }
    }


    /// Week View
    func WeekView(_ week: Date.Week) -> some View {
        HStack(spacing: 10) {
            ForEach(week) { day in
                WeekColumn(date: day.date, isSelected: viewModel.isSelected(day))
                .hSpacing(.center)
                .onTapGesture {
                    /// Updating Selected Day
                    withAnimation {
                        viewModel.selectedDate = day.date
                        print(day.date)
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
                            if value.rounded() == 15 && viewModel.createWeek {
                                viewModel.paginateWeek()
                                viewModel.createWeek = false
                            }
                        }
                }
            }
        }
    }

}

struct WeekSliderView_Previews: PreviewProvider {

    static var previews: some View {
        WeekSliderView(viewModel: WeekSliderViewModel())
    }
}
