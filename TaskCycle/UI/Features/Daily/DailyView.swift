//
//  DailyView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DailyView: View {

    /// Task Manager Properties
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var tasks: [Task] = sampleTasks.sorted(by: { $1.creationDate > $0.creationDate })
    @State private var createNewTask: Bool = false

    /// Animation Namespace
    @Namespace private var animation

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HeaderView()
                .vSpacing(.top)
        }
        .background(Color.backgroundColor)
        .onAppear {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()

                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }

                weekSlider.append(currentWeek)

                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        }
    }
}


// MARK: - Header View

extension DailyView {

    @ViewBuilder
    func HeaderView() -> some View {
        VStack (alignment: .leading, spacing: 6) {
            HStack (spacing: 5) {
                Text(currentDate.format("MMMM"))
                    .foregroundColor(.darkBlue)
                Text(currentDate.format("YYYY"))
                    .foregroundColor(.gray)
            }
            .font(.title.bold())

            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)

            /// Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
            .padding(.top)

        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing) {
            ProfileImage()
        }
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex) { newValue in
            /// Creating When it reaches first/last Page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
}


// MARK: - Header View

extension DailyView {

    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 10) {
            ForEach(week) { day in
                VStack (spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout).fontWeight(.medium)
                        .foregroundColor(.gray)

                    Text(day.date.format("dd"))
                        .font(.callout).fontWeight(.bold)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundColor(.gray)
                                .shadow(radius: 1).opacity(0.5)
                        )
                        .background { SelectedDayCover(day) }

                }
                .hSpacing(.center)
                .onTapGesture {
                    /// Updating Current Date
                    withAnimation {
                        currentDate = day.date
                    }
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
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }

    @ViewBuilder
    func SelectedDayCover(_ day: Date.WeekDay) -> some View {
        if isSameDate(day.date, currentDate) {
            Circle()
                .fill(Color.darkBlue)
                .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
        }

        /// Indicator to Show, Which is Today;s Date
        if day.date.isToday {
            Circle()
                .fill(.cyan)
                .frame(width: 5, height: 5)
                .vSpacing(.bottom)
                .offset(y: 12)
        }
    }

    func paginateWeek() {
        /// SafeCheck
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting New Week at 0th Index and Removing Last Array Item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }

            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Appending New Week at Last Index and Removing First Array Item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }

        print(weekSlider.count)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
