//
//  ProfileImage.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-07.
//

import SwiftUI

struct ProfileImage: View {
    
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .foregroundColor(.gray)
            .aspectRatio(contentMode: .fill)
            .frame(width: 45, height: 45)
            .cornerRadius(45)
            .overlay(
                RoundedRectangle(cornerRadius: 45)
                    .stroke(Color.backgroundColor, lineWidth: 2)
            )
            .shadow(radius: 0.5)
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage()
    }
}
