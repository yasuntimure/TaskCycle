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

    @ObservedObject var vm: NoteViewModel

    @FocusState var focusState: NoteTextFields?

    var body: some View {
        VStack (alignment: .leading) {
            TextField("Title...", text: $vm.title)
                .titleFont(for: vm.noteType ?? .empty)
                .focused($focusState, equals: .noteTitle)
                .onSubmit { focusState = .noteDescription }
                .padding(.horizontal)

            VStack (alignment: .leading) {
                if vm.isNoteConfVisible {
                    NoteConfigurationView()
                } else {
                    switch vm.noteType ?? .empty {
                    case .empty: 
                        TextField("Description . . .", text: $vm.description, axis: .vertical)
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .focused($focusState, equals: .noteDescription)
                            .padding([.horizontal,.top])
                    case .todo:
                        ToDoListView()
                    case .board:
                        BoardNoteView()
                    }
                }
            }
            .hSpacing(.leading)
            .vSpacing(.top)
        }
        .onAppear { focusState = vm.initialFocusState() }
        .onDisappear {
            if vm.title.isEmpty {
                vm.title = "Quick Note"
            }
            vm.updateNote()
            parentVM.fetchNotes()
        }
        .environmentObject(vm)
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
                vm.setNoteType(.empty)
            }
            
            VStack (alignment: .leading, spacing: 10) {
                Text("Add New")
                    .font(.footnote).bold()
                    .foregroundStyle(theme.mTintColor)
                CustomButton("To Do List", image: "checkmark.square") {
                    vm.setNoteType(.todo)
                }
                if !vm.isCardDetail {
                    CustomButton("Kanban Board", image: "tablecells") {
                        vm.setNoteType(.board)
                    }
                }
            }
        }.padding()
    }

}

#Preview {
    NoteView(vm: NoteViewModel(Mock.note))
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
