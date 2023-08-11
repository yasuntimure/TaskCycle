//
//  DailyView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DailyView<VM>: View where VM: DailyViewModelProtocol {
    
    @StateObject var viewModel: VM

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            VStack (alignment: .leading, spacing: 6) {
                HeaderDateView()

                /// Week Slider
                WeekSliderView(viewModel: viewModel.weekSliderViewModel)
                    .padding(.horizontal, -15)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 90)
                    .padding(.top)

            }
            .hSpacing(.leading)
            .overlay(alignment: .topTrailing) { ProfileImage() }
            .padding(15)
            .background(.white)
            .vSpacing(.top)
        }
        .background(Color.backgroundColor)
    }
}


struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(viewModel: DailyViewModel())
    }
}
