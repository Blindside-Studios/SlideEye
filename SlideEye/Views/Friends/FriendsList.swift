import SwiftUI
import CoreLocation

struct FriendsList: View {
    @Environment(ModelData.self) var modelData
    
    @State private var sortByFavorites = false
    @State private var shouldPresentAddPeopleSheet = false
    @State private var newFriendProfilePicture = UIImage(systemName: "person.fill")!
    
    var filteredFriends: [Friend] {
        modelData.friends.reversed().filter { friend in
            (!sortByFavorites || friend.isFavorite)
        }
    }
    
    @State private var friendToAdd: Friend
    
    let nullFriend = Friend(id: 0000, quotes: [Friend.Quote(id: 000, text: "Example Quote", year: 2024)])
    
    public init(){
        _sortByFavorites = State(initialValue: false)
        _shouldPresentAddPeopleSheet = State(initialValue: false)        
        _friendToAdd = State(initialValue: nullFriend)
    }
    
    func resetFriendToAdd(){
        friendToAdd = nullFriend
        newFriendProfilePicture = UIImage(systemName: "person.fill")!
    }
    
    func constructFriendToAdd(friend: Friend, profilePicture: UIImage) -> Friend
    {
        let imageName = String(friend.id)+"_00"
        _ = saveImage(image: profilePicture, imageName: imageName)
        
        let constructedFriend = Friend(id: friend.id, name: friend.name, occupation: friend.occupation, location: friend.location, city: friend.city, country: friend.country, continent: friend.continent, timeZoneID: friend.timeZoneID, isFavorite: friend.isFavorite, notes: friend.notes, imageName: imageName)
        return constructedFriend
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // Function to save image data
    func saveImage(image: UIImage, imageName: String) -> Bool {
        if let imageData = image.jpegData(compressionQuality: 1) ?? image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
            do {
                try imageData.write(to: filename, options: [.atomic, .completeFileProtection])
                return true
            } catch {
                print("Unable to save image.")
                return false
            }
        }
        return false
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
                            NewFriendPage(friendDetails: $friendToAdd, profilePicture: $newFriendProfilePicture)
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
                                            let addableFriend = constructFriendToAdd(friend: friendToAdd, profilePicture: newFriendProfilePicture)
                                            modelData.friends.append(addableFriend)
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
        
        // TODO: this does not work, fix it, miraculix
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
