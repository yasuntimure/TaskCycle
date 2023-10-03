//
//  NoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI
import FirebaseFirestoreSwift

enum NoteTextFields: Hashable {
    case noteTitle
    case noteDescription
    case kanbanTitle
    case kanbanTaskTitle
    case kanbanTaskDescription
}

struct NoteView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var parentVM: NotesViewModel

    @ObservedObject var viewModel: NoteViewModel

    @FocusState var focusState: NoteTextFields?

    var body: some View {
        VStack (alignment: .leading) {
            TextField("Title...", text: $viewModel.title)
                .titleFont(for: viewModel.noteType ?? .empty)
                .focused($focusState, equals: .noteTitle)
                .onSubmit { focusState = .noteDescription }
                .padding(.horizontal)
            
            TextField("Description . . .", text: $viewModel.description, axis: .vertical)
                .descriptionFont(for: viewModel.noteType ?? .empty)
                .foregroundColor(.secondary)
                .focused($focusState, equals: .noteDescription)
                .padding(.horizontal)
                .descriptionPadding(for: viewModel.noteType)
            
            GeometryReader { geometry in
                VStack (alignment: .leading) {
                    if viewModel.isNoteConfVisible {
                        NoteConfigurationView()
                    } else {
                        switch viewModel.noteType ?? .empty {
                        case .empty: 
                            Divider().opacity(0).frame(height: 1)
                        case .todo: 
                            ToDoListView(viewModel: ToDoListViewModel(service: ToDoNoteService(noteId: viewModel.id)))
                        case .board:
                            BoardNoteBuilder.make(id: viewModel.id,
                                                  height: geometry.size.height)
                        }
                    }
                }
                .hSpacing(.leading)
            }
        }
        .onAppear { focusState = viewModel.initialFocusState() }
        .onDisappear {
            if viewModel.title.isEmpty {
                viewModel.title = "Quick Note"
            }
            viewModel.updateNote()
            parentVM.fetchNotes()
        }
    }
    
    @ViewBuilder
    private func CustomButton(_ title: String,
                              image: String,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack (spacing: 3) {
                Image(systemName: image)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
            }
            .foregroundStyle(.gray)
            .padding(10)
            .layeredBackground(Color.backgroundColor, cornerRadius: 8)
        }
    }
    
    @ViewBuilder
    private func NoteConfigurationView() -> some View {
        VStack (alignment: .leading, spacing: 25) {
            CustomButton("Empty Page", image: "plus") {
                viewModel.setNoteType(.empty)
                viewModel.updateNote()
            }
            
            VStack (alignment: .leading, spacing: 10) {
                Text("Add New")
                    .font(.footnote).bold()
                    .foregroundStyle(theme.mTintColor)
                CustomButton("To Do List", image: "checkmark.square") {
                    viewModel.setNoteType(.todo)
                }
                CustomButton("Kanban Board", image: "tablecells") {
                    viewModel.setNoteType(.board)
                }
            }
        }.padding()
    }

}

#Preview {
    NoteView(viewModel: NoteViewModel(Mock.note))
        .environmentObject(Theme())
        .environmentObject(NotesViewModel())
}

fileprivate extension TextField {
    func titleFont(for noteType: NoteType) -> some View {
        switch noteType {
        case .empty:
            return self.font(.largeTitle).bold()
        case .todo:
            return self.font(.title).bold()
        case .board:
            return self.font(.title2).bold()
        }
    }
    
    func descriptionFont(for noteType: NoteType) -> some View {
        switch noteType {
        case .empty:
            return self.font(.title2)
        case .todo:
            return self.font(.title3)
        case .board:
            return self.font(.body)
        }
    }
    
}

fileprivate extension View {
    @ViewBuilder
    func descriptionPadding(for noteType: NoteType?) -> some View {
        if let noteType = noteType, noteType == .empty {
            self.vSpacing(.top)
        }
        self
    }
}


struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}
extension View {
    func dismissKeyboard() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
