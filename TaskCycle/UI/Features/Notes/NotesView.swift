//
//  NotesView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-18.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var theme: Theme

    @ObservedObject var viewModel: NotesViewModel

    @State var noteStack: [NoteModel] = []

    var body: some View {
        NavigationStack(path: $noteStack) {
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

                    PlusButton() {
                        viewModel.saveNewNote { note in
                            noteStack.append(note)
                        }
                    }
                    .vSpacing(.bottom).hSpacing(.trailing)
                    .padding([.trailing,.bottom], 20)
                }
            }
            .navigationDestination(for: NoteModel.self) { note in
                NoteBuilder.make(note)
            }
        }
    }
}

// MARK: - HeaderView

extension NotesView {

    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            HStack {
                // Title
                Text("Notes")
                    .font(.title.bold())
                    .hSpacing(.leading)
                    .foregroundColor(theme.mTintColor)

                // Edit Button
                ZStack {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                    EditButton()
                        .foregroundColor(.clear)
                }

            }
            .padding([.top, .horizontal])

            Rectangle()
                .frame(width: ScreenSize.width, height: 2)
                .foregroundColor(.backgroundColor)
        }
    }
}

// MARK: - NoteNavigationRow

extension NotesView {

    @ViewBuilder
    private func NoteNavigationRow() -> some View {
        ForEach ($viewModel.notes) { $note in
            NavigationLink {
                NoteView(viewModel: NoteViewModel(note))
            } label: {
                NoteRow(note: $note)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .hSpacing(.leading)
            .layeredBackground(Color.backgroundColor)
            .cornerRadius(20)
        }
        .onDelete(perform: viewModel.deleteItems(at:))
        .onMove(perform: viewModel.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

}

struct
NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel(repository: NotesRepository()))
            .environmentObject(Theme())
    }
}
