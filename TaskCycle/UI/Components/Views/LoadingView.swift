//
//  LoadingView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-29.
//

import SwiftUI

// MARK: - LoadingView

struct LoadingView: View {
    
    @State var rotation: Double = 360
    
    var body: some View {
        Circle()
            .trim(from: 3/10, to: 1)
            .stroke(lineWidth: 4)
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(self.rotation))
            .onAppear { rotation = (rotation == 0) ? 360 : 0 }
            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false))
            .foregroundColor(Color.primary)
        
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
