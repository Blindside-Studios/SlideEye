import SwiftUI

struct FriendsList: View {
    @Environment(ModelData.self) var modelData
    @State private var sortByFavorites = false
    @State private var shouldPresentAddPeopleSheet = false
    
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
                HStack {
                    ProfilePicture(image: Image("person.fill.badge.plus"))
                        .frame(width: 50, height: 50)
                    Text("Add new friend...")
                    Spacer()
                }
                .gesture(TapGesture().onEnded {
                    shouldPresentAddPeopleSheet.toggle()
                })
                .sheet(isPresented: $shouldPresentAddPeopleSheet){
                } content: {
                    VStack{
                        ZStack{
                            Rectangle()
                                .foregroundStyle(.bar)
                                .frame(height: 50)
                            HStack{
                                Button("Cancel") { shouldPresentAddPeopleSheet.toggle() }
                                Spacer()
                                Button("Done") 
                                {
                                    // add logic to add people here
                                    shouldPresentAddPeopleSheet.toggle()
                                }
                            }
                            .padding(15)
                        }
                        Spacer()
                    }
                    }
                
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
