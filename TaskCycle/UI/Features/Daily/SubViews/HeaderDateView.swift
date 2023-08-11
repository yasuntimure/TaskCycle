//
//  DailyHeaderView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-10.
//

import SwiftUI

struct HeaderDateView: View {

    @State var date: Date = .init()

    var body: some View {
        VStack (alignment: .leading, spacing: 6) {
            HStack (spacing: 5) {
                Text(date.format("MMMM"))
                    .foregroundColor(.darkBlue)
                Text(date.format("YYYY"))
                    .foregroundColor(.gray)
            }
            .font(.title.bold())

            Text(date.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
        }
    }
}

struct HeaderDateView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderDateView(date: .init())
    }
}
