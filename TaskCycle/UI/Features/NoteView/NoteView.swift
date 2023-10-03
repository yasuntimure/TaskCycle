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
                            ToDoListView()
                        case .board:
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    LazyVGrid(columns: getGridColumns()) {
                                        ForEach($viewModel.kanbans, id: \.id) { $kanban in
                                            KanbanColumnView(kanban: $kanban)
                                                .frame(height: geometry.size.height)
                                                .environmentObject(viewModel)
                                        }
                                        AddColumnButton()
                                    }
                                }
                                .padding(.horizontal)
                            }
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
    
    @ViewBuilder
    func ToDoListView() -> some View {
        ZStack {
            List {
                ForEach ($viewModel.items) { $item in
                    ToDoRow(item: $item)
                        .padding(.vertical, -5)
                        .hSpacing(.leading)
                }
                .onDelete(perform: viewModel.deleteItems(at:))
                .onMove(perform: viewModel.moveItems(from:to:))
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }
            
            PlusButton() {
                viewModel.addNewItem()
            }
            .hSpacing(.trailing).vSpacing(.bottom)
            .padding([.trailing, .bottom], 20)
        }
    }
    
    func getGridColumns() -> [GridItem] {
        var columns: [GridItem] = []
        viewModel.kanbans.forEach { _ in
            columns.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        }
        columns.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        return columns
    }
    
    @ViewBuilder
    private func AddColumnButton() -> some View {
        Button {
            withAnimation {
                viewModel.addKanbanColumn()
            }
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Add Column")
            }
            .font(.body).bold()
            .foregroundColor(.secondary)
            .hSpacing(.center).vSpacing(.center)
            .layeredBackground(.backgroundColor.opacity(0.4), cornerRadius: 8)
            .padding(.top, 42).padding(.bottom, 18).padding(.horizontal).padding(.leading, -8)
        }
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
