//
//  NewListView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-29.
//

import SwiftUI

struct NewNoteView: View {

    @EnvironmentObject var viewModel: NotesViewModel

    @FocusState var titleFocused: Bool

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack (spacing: 30)  {
                Text("Add New Note")
                    .font(.system(size: 30)).bold()
                    .padding(.top, 35)
                    .shadow(radius: 1, x: 1, y: 1)
                    .hSpacing(.leading)

                VStack (spacing: 15) {
                    HStack (spacing: 10) {
                        IconView(selectedEmoji: $viewModel.newNote.emoji)

                        TextField("Title", text: $viewModel.newNote.title)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($titleFocused)
                            .padding(15)
                            .padding(.leading, 5)
                            .background(Color.backgroundColor)
                            .cornerRadius(20)
                            .shadow(radius: 1)

                    }

                    TextField("Description", text: $viewModel.newNote.description)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)
                        .padding(.vertical, 15)
                        .padding(.leading, 5)
                        .background(Color.backgroundColor)
                        .cornerRadius(20)
                        .shadow(radius: 1)

                    NoteTypeView(type: $viewModel.noteType)
                        .padding(.top)

                }

                PrimaryButton(title: "Save") {
                    viewModel.saveNewNote()
                    viewModel.fetchNotes()
                    dismiss()
                }
                .frame(width: ScreenSize.width)
                .shadow(radius: 2)
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
            .padding(.top)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.errorMessage))
            }
            .onAppear {
                titleFocused = true
            }
        }

    }


}

enum NoteType {
    case empty, toDo, board
}

struct NoteTypeView: View {

    @Binding var type: NoteType

    var body: some View {
        HStack (spacing: 10) {
            TypeButton("Default", isSelected: (type == .empty)) { type = .empty }
            TypeButton("To Do", isSelected: (type == .toDo)) { type = .toDo }
            TypeButton("Board", isSelected: (type == .board)) { type = .board }
        }

    }

    @ViewBuilder
    private func TypeButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .padding(.vertical, 10)
            .frame(width: (ScreenSize.defaultWidth-30)/3)
            .bold()
            .foregroundColor(isSelected ? Color.white : Color.mTintColor)
            .background(isSelected ? Color.mTintColor : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mTintColor, lineWidth: 2)
            )
    }
}

struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
            .environmentObject(NotesViewModel(userId: "5JK0lwRArPULkWLO6Xf9DPxdo073"))
    }
}
