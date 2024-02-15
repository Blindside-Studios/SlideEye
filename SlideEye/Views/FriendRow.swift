import SwiftUI

struct FriendRow: View {
    var friend: Friend
    
    var body: some View {
        HStack {
            friend.profilePicture
                .resizable()
                .frame(width:50, height:50)
            Text(friend.name)
            Spacer()
        }
    }
}

#Preview {
    Group {
        FriendRow(friend: friends[0])
        FriendRow(friend: friends[1])
        FriendRow(friend: friends[2])
    }
}
