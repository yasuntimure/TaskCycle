//
//  NotesView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-18.
//

import SwiftUI

struct NotesView: View {

    @ObservedObject var viewModel: NotesViewModel

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach ($viewModel.notes) { $note in
                        NoteRow(note: $note)
                    }
                    .onDelete(perform: viewModel.deleteItems(at:))
                    .onMove(perform: viewModel.moveItems(from:to:))
                }
                .background(.clear)
                .refreshable { viewModel.fetchNotes() }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                    ToolbarItem(placement: .navigationBarTrailing) { settingsViewNavigation }
                }
                .listStyle(.plain)
                .navigationTitle("Notes")
                .sheet(isPresented: $viewModel.newNotePresented) {
                    NewNoteView()
                        .presentationDetents([.fraction(0.45)])

                }
                .sheet(isPresented: $viewModel.settingsPresented) {
                    SettingsView()
                        .presentationDetents([.fraction(0.45)])
                }

                PlusButton(size: 25) {
                    viewModel.newNotePresented = true
                }
                .vSpacing(.bottom).hSpacing(.trailing)
                .padding([.trailing,.bottom], 20)

            }
            .sheet(isPresented: $viewModel.settingsPresented) {
                SettingsView()
                    .presentationDetents([.fraction(0.45)])
            }
        }
        .environmentObject(viewModel)

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
                viewModel.settingsPresented = true
            }

    }
}


struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel(userId: " "))
    }
}
