import SwiftUI
import EmojiPicker

struct IconView: View {

    @Binding var selectedEmoji: Emoji?
    @State var displayEmojiPicker: Bool = false

    var body: some View {
        Button {
            displayEmojiPicker = true
        } label: {
            if let emoji = self.selectedEmoji?.value {
                Text(emoji)
                    .font(.largeTitle)
                    .padding(5)
                    .background(Color.backgroundColor)
                    .cornerRadius(20)
                    .shadow(radius: 1)
            } else {
                VStack {
                    Image(systemName: "doc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.secondary)

                    Text("Add Icon")
                        .foregroundColor(.secondary)
                        .font(.system(size: 9))
                }
                .frame(width: 40, height: 30)
                .padding(12)
                .background(Color.backgroundColor)
                .cornerRadius(20)
                .shadow(radius: 1)
            }
        }
        .sheet(isPresented: $displayEmojiPicker) {
            NavigationView {
                EmojiPickerView(selectedEmoji: $selectedEmoji, selectedColor: .orange)
                    .navigationTitle("Emojis")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

//struct IconView_Previews: PreviewProvider {
//    static var previews: some View {
//        IconView(selectedEmoji: .constant(<#T##value: Emoji?##Emoji?#>))
//    }
//}



