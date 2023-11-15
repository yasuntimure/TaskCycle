//
//  NotesView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-18.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var theme: Theme
    @State var isEditing: Bool = false
    @Environment(\.showError) private var showError

    @ObservedObject var vm: NotesViewModel

    @State var noteStack: [Note] = []

    var body: some View {
        NavigationStack(path: $noteStack) {
            VStack {
                HeaderView()

                ZStack {
                    List {
                        NoteNavigationRow()
                    }
                    .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
                    .animation(.spring, value: isEditing)
                    .listStyle(.plain)
                    .background(.clear)
                    .refreshable { vm.fetchNotes() }

                    PlusButton() {
                        vm.saveNewNote { note in
                            noteStack.append(note)
                        }
                    }
                    .vSpacing(.bottom).hSpacing(.trailing)
                    .padding([.trailing,.bottom], 20)
                }
            }
            .navigationDestination(for: Note.self) { note in
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

                Button(action: { self.isEditing.toggle() }) {
                    Image(systemName: isEditing ? "square.3.layers.3d.slash" : "square.3.layers.3d")
                        .resizable()
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
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
        ForEach ($vm.notes) { $note in
            NavigationLink {
                NoteView(vm: NoteViewModel(note))
            } label: {
                NoteRow(note: $note)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            .hSpacing(.leading)
            .layeredBackground(Color.backgroundColor)
            .cornerRadius(20)
        }
        .onDelete(perform: vm.deleteItems(at:))
        .onMove(perform: vm.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

}

struct
NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(vm: NotesViewModel())
            .environmentObject(Theme())
    }
}
