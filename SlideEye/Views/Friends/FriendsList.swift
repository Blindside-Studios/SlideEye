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
                Section
                {
                    HStack {
                        ProfilePicture(image: Image(systemName: "plus"))
                            .image.frame(width: 200, height: 200)
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
                        .shadow(radius: 10)
                    }
                }
                
                Section
                {
                    HStack
                    {
                        ProfilePicture(image: Image(systemName: "star"))
                            .image.frame(width: 200, height: 200)
                            .frame(width: 50, height: 50)
                        Toggle (isOn: $sortByFavorites) { Text("Favorites only") }
                            .frame(height: 50)
                    }
                
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
            }
        } detail: {
            Text("Pick a friend")
        }
        
        // this does not work, fix it, miraculix
        .toolbar(content: {
            EditButton()
            FavoriteButton(isSet: $sortByFavorites)
                .gesture(TapGesture().onEnded {
                    sortByFavorites.toggle()
                })
        })
    }
}

#Preview {
    FriendsList()
        .environment(ModelData())
}
