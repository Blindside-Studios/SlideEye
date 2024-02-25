import SwiftUI

struct NotesPage: View {
    var friendName: String
    var backgroundImage: Image
    @Binding var notes: String
    
    var body: some View {
        ZStack
        {
            BlurredBackground(image: backgroundImage)
                .opacity(0.4)
            ScrollView{
                TextField("Take notes on \(friendName) here", text: $notes)
                    .padding(.vertical, 70)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NotesPage(friendName: "ExampleFriend", backgroundImage: Image("DaniRojas"), notes: .constant("These are some notes that can be edited."))
}
