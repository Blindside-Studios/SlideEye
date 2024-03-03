import SwiftUI

struct FriendsList: View {
    @Environment(ModelData.self) var modelData
    
    @State private var sortByFavorites = false
    @State private var shouldPresentAddPeopleSheet = false
    
    var filteredFriends: [Friend] {
        modelData.friends.reversed().filter { friend in
            (!sortByFavorites || friend.isFavorite)
        }
    }
    
    @State private var friendToAdd: Friend
    
    public init(){
        _sortByFavorites = State(initialValue: false)
        _shouldPresentAddPeopleSheet = State(initialValue: false)
        // TODO: Set friend to an empty Friend object, because this code will not work if you don't already have friends!
        _friendToAdd = State(initialValue: ModelData().friends[0])
    }
    
    func resetFriendToAdd(){
        // TODO: Actually reset friend
        friendToAdd = ModelData().friends[0]
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
                        ZStack
                        {
                            NewFriendPage(friendDetails: $friendToAdd)
                            VStack{
                                ZStack{
                                    Rectangle()
                                        .foregroundStyle(.bar)
                                        .frame(height: 50)
                                    HStack{
                                        Button("Cancel") { shouldPresentAddPeopleSheet.toggle(); resetFriendToAdd() }
                                        Spacer()
                                        Button("Save")
                                        {
                                            modelData.friends.append(friendToAdd)
                                            modelData.saveChanges(friendsList: modelData.friends)
                                            shouldPresentAddPeopleSheet.toggle()
                                            resetFriendToAdd()
                                        }
                                    }
                                    .padding(15)
                                }
                                Spacer()
                            }
                            .shadow(radius: 10)
                        }
                    }
                }
                
                Section("Debug")
                {
                    Button(action: {
                        modelData.loadExampleFriends()
                    }) {
                        Text("Append Demo Items")
                    }
                    
                    Button(action: {
                        modelData.deleteAllFriends()
                    }) {
                        Text("Remove All Saved Friends")
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
                }
            }
            .animation(.default, value: filteredFriends)
            .navigationTitle("My friends")
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
