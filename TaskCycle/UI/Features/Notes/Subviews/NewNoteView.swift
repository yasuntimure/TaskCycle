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
        ZStack {
            ScrollView (.vertical)  {
                Text("Add New Note")
                    .font(.system(size: 32)).bold()
                    .padding(.top, 35)
                    .shadow(radius: 1, x: 1, y: 1)

                VStack {
                    TextField("Title", text: $viewModel.newNote.title)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .frame(height: 60)
                        .focused($titleFocused)

                    TextField("Description", text: $viewModel.newNote.description)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .frame(minHeight: 80, maxHeight: 500)
                }
                .padding(.horizontal, 25)

                PrimaryButton(title: "Save") {
                    viewModel.saveNewNote()
                    viewModel.fetchNotes()
                    dismiss()
                }
                .frame(width: ScreenSize.width)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(viewModel.errorMessage))
                }
            }

        }
        .onAppear {
            titleFocused = true
        }
    }
}

struct NewListView_Previews: PreviewProvider {
    static var previews: some View {
        NewNoteView()
            .environmentObject(NotesViewModel(userId: ""))
    }
}

