import SwiftUI

struct FriendsList: View {
    var body: some View {
        NavigationSplitView {
            List(friends) { friend in
                NavigationLink {
                    FriendDetail(friend: friend)
                } label: {
                    FriendRow(friend: friend)
                }
            }
            .navigationTitle("My friends")
        } detail: {
            Text("Pick a friend")
        }
    }
}

#Preview {
    FriendsList()
}
