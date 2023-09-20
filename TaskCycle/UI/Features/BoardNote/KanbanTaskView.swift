//
//  KanbanTask.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-19.
//

import SwiftUI

struct KanbanTaskView: View {

    @EnvironmentObject var theme: Theme

    @Binding var note: NoteModel

    var body: some View {
        HStack(spacing: 10) {
            VStack {
                if let emoji = note.emoji {
                    Text(emoji)
                        .font(.title)
                } else {
                    Image(systemName: note.type()?.systemImage ?? NoteType.empty.systemImage)
                        .font(.title)
                        .foregroundColor(theme.mTintColor)
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                }
            }

            VStack (alignment: .leading, spacing: 2) {
                TextField("Title...", text: $note.title, axis: .vertical)
                    .font(.subheadline.bold())
                    .multilineTextAlignment(.leading)

                if !note.description.isEmpty {
                    TextField("Description...", text: $note.description, axis: .vertical)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                }
            }
        }
        .hSpacing(.leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 9)
        .layeredBackground(.white, cornerRadius: 8)
        .border(.red)
    }
}

#Preview {
    ZStack {
        Color.backgroundColor
            .ignoresSafeArea()

        KanbanTaskView(note: .constant(Mock.note))
            .environmentObject(Theme())
            .padding()
            .padding(.trailing, 100)
    }


}


struct TextFieldHeightView: View {
    @Binding var text: String

    var body: some View {
        GeometryReader { geometry in
            TextField("Title...", text: $text, axis: .vertical)
                .font(.subheadline.bold())
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .background(SizePreferenceSetter())
        }
        .onPreferenceChange(SizePreferenceKey.self) { size in
            print("Height of TextField is: \(size.height)")
        }
    }
}

struct SizePreferenceSetter: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
