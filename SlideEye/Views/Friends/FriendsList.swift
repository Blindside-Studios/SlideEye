import SwiftUI

struct FriendsList: View {
    @Environment(ModelData.self) var modelData
    @State private var sortByFavorites = false
    
    var filteredFriends: [Friend] {
        modelData.friends.filter { friend in
            (!sortByFavorites || friend.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView
        {
            List
            {
                Toggle (isOn: $sortByFavorites) { Text("Favorites only") }
                
                ForEach(filteredFriends)
                { friend in
                    NavigationLink {
                        FriendDetail(friend: friend)
                    } label: {
                        FriendRow(friend: friend)
                    }
                }
                .animation(.default, value: filteredFriends)
                .navigationTitle("My friends")
            }
        } detail: {
            Text("Pick a friend")
        }
    }
}

#Preview {
    FriendsList()
        .environment(ModelData())
}
