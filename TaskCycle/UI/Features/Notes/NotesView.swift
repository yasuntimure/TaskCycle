//
//  NotesView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-18.
//

import SwiftUI

struct NotesView: View {

    @State var settingsViewPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                        ToolbarItem(placement: .navigationBarTrailing) { settingsViewNavigation }
                    }
                    .sheet(isPresented: $settingsViewPresented) {
                        SettingsView()
                            .presentationDetents([.fraction(0.45)])
                    }
            }
        }
    }
}

// MARK: - Settings View Navigation

extension NotesView {

    var settingsViewNavigation: some View {
        Image(systemName: "gear")
            .resizable()
            .foregroundColor(.primary)
            .frame(width: 25, height: 25)
            .onTapGesture {
//                viewModel.settingsViewPresented = true
            }

    }
}


struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
