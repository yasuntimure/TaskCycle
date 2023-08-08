//
//  DailyView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DailyView: View {

    @State private var currentDate: Date = .init()

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HeaderView()
                .vSpacing(.top)
        }

    }


    /// Header View
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

        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing) {
            ProfileImage()
        }
        .padding(15)
        .background(.white)
    }

    
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
