import SwiftUI

struct ContentView: View {
    var body: some View {
        FriendsList()
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
