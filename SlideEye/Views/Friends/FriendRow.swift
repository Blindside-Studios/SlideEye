import SwiftUI

struct FriendRow: View {
    @Environment(ModelData.self) var modelData
    
    var friend: Friend
    
    @State private var showingDeletionConfirmationDialogue = false
    @State private var deletedFriendName = "UNIDENTIFIED_FRIEND"
    @State private var deleteFriendIndex = 0
    
    func toggleIsFavoriteOnFriend(friendID: Int){
        let friendIndex = modelData.friends.firstIndex(where: { $0.id == friendID })!
        modelData.friends[friendIndex].isFavorite.toggle()
        modelData.saveLocalChanges()
    }
    
    func toggleIsPinnedOnFriend(friendID: Int){
        let friendIndex = modelData.friends.firstIndex(where: { $0.id == friendID })!
        modelData.friends[friendIndex].isPinned.toggle()
        modelData.saveLocalChanges()
    }
    
    func deleteFriend(friendID: Int){
        let friendIndex = modelData.friends.firstIndex(where: { $0.id == friendID })!
        deleteFriendIndex = friendIndex
        deletedFriendName = modelData.friends[friendIndex].name
        showingDeletionConfirmationDialogue.toggle()
    }
    
    var body: some View {
        NavigationLink {
            FriendDetail(friend: friend)
        } label: {
            HStack {
                ProfilePicture(image: friend.profilePicture)
                    .clipShape(Circle())
                    .frame(width:50, height:50)
                Text(friend.name)
                Spacer()
                
                if friend.isFavorite
                {
                    Image(systemName: "star.fill")
                }
            }
        }
        .contextMenu {
            Button {
                toggleIsFavoriteOnFriend(friendID: friend.id)
            } label: {
                if (friend.isFavorite) { Label("Unfavorite", systemImage: "star.slash.fill") }
                else { Label("Favorite", systemImage: "star.fill") }
            }
            Button {
                toggleIsPinnedOnFriend(friendID: friend.id)
            } label: {
                if (friend.isPinned) { Label("Unpin", systemImage: "pin.slash.fill") }
                else { Label("Pin", systemImage: "pin.fill") }
            }
            Divider()
            Button(role: .destructive, action: {
                deleteFriend(friendID: friend.id)
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading) {
                Button {
                    toggleIsFavoriteOnFriend(friendID: friend.id)
                } label: {
                    if (friend.isFavorite) { Label("Unfavorite", systemImage: "star.slash.fill") }
                    else { Label("Favorite", systemImage: "star.fill") }
                }
            }
        .swipeActions(edge: .leading) {
                Button {
                    toggleIsPinnedOnFriend(friendID: friend.id)
                } label: {
                    if (friend.isPinned) { Label("Unpin", systemImage: "pin.slash.fill") }
                    else { Label("Pin", systemImage: "pin.fill") }
                }
            }
        .swipeActions(edge: .trailing) {
                Button {
                    deleteFriend(friendID: friend.id)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        .confirmationDialog("Are you sure?", isPresented: $showingDeletionConfirmationDialogue) {
                Button("Delete", role: .destructive) {
                        modelData.friends.remove(at: deleteFriendIndex)
                        modelData.saveLocalChanges()
                }
                Button("Cancel", role: .cancel) { showingDeletionConfirmationDialogue = false }
            } message: {
                Text("\(deletedFriendName) will be permanently deleted. This cannot be undone.")
            }
    }
}

#Preview {
    let friends = ModelData().friends
    return Group {
        FriendRow(friend: friends[0])
        FriendRow(friend: friends[1])
        FriendRow(friend: friends[2])
    }
}
