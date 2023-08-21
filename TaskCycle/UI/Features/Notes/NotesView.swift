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
            VStack {
                HeaderView()

                ZStack {
                    List {
                        NoteNavigationRow()
                    }
                    .listStyle(.plain)
                    .background(.clear)
                    .refreshable {
                        viewModel.fetchNotes()
                    }
                    .sheet(isPresented: $viewModel.newNotePresented) {
                        NewNoteView()
                            .presentationDetents([.fraction(0.45)])

                    }
                    .sheet(isPresented: $viewModel.settingsPresented) {
                        SettingsView()
                            .presentationDetents([.fraction(0.45)])
                    }

                    CustomEditButton()

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
        }
        .environmentObject(viewModel)
    }

    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            HStack {
                // Title
                Text("Notes")
                    .font(.title.bold())
                    .hSpacing(.leading)
                    .foregroundColor(.mTintColor)

                // Settings Button
                Image(systemName: "gearshape")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 28, height: 28)
                    .onTapGesture {
                        viewModel.settingsPresented = true
                    }
            }
            .padding([.top, .horizontal])

            Rectangle()
                .frame(width: ScreenSize.width, height: 2)
                .foregroundColor(.backgroundColor)
        }
    }

    @ViewBuilder
    private func NoteNavigationRow() -> some View {
        ForEach ($viewModel.notes) { $note in
            NavigationLink {
                NoteView(type: note.type())
            } label: {
                NoteRow(note: $note)
            }
            .padding(.vertical, -5)
        }
        .onDelete(perform: viewModel.deleteItems(at:))
        .onMove(perform: viewModel.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

// MARK: - Toolbar

extension NotesView {

    @ViewBuilder
    private func CustomEditButton() -> some View {
        ZStack {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .foregroundColor(.secondary)
                .frame(width: 28, height: 28)
            EditButton()
                .foregroundColor(.clear)
        }
        .hSpacing(.leading)
        .vSpacing(.bottom)
        .padding([.leading,.bottom], 28)
    }

}


struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel(userId: " "))
    }
}
