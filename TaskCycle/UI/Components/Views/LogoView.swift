//
//  LogoView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .stroke(lineWidth: 25)

                Image(systemName: "note.text")
                    .resizable()
                    .frame(width: proxy.size.width/2, height: proxy.size.width/2)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
