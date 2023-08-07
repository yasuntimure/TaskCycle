//
//  DateSlider.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DateSliderView: View {

    @State var dates: [String: TimeInterval] = [:]

    var body: some View {

        ScrollViewReader { proxy in
            ScrollView (.horizontal) {
                LazyHStack {
                    ForEach(dates.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        VStack {
                            Text(value.monthString()).font(.body)
                            Text(value.dayString()).font(.headline)
                        }
                        .id(key)
                    }
                }
            }
            .onAppear {
                dates = generateDateDictionary()
                let today = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
                withAnimation {
                    proxy.scrollTo(today, anchor: .center)

                }
            }
        }
        
    }

    func generateDateDictionary() -> [String: TimeInterval] {
        var dateDict: [String: TimeInterval] = [:]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()),
              let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) else {
            return dateDict
        }

        var currentDate = startDate
        while currentDate <= endDate {
            let dateString = dateFormatter.string(from: currentDate)
            dateDict[dateString] = currentDate.timeIntervalSinceReferenceDate
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return dateDict
    }



}

struct DateSlider_Previews: PreviewProvider {
    static var previews: some View {
        DateSliderView()
    }
}

extension TimeInterval {
    func formatedDate() -> Date {
        return Date(timeIntervalSinceReferenceDate: self)
    }

    func monthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self.formatedDate())
    }

    func dayString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self.formatedDate())
    }
}
