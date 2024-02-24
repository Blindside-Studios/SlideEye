import SwiftUI

struct FriendDetail: View {
    @Environment(ModelData.self) var modelData // this line makes the preview crash
    var friend: Friend
    
    @State private var shouldPresentMapSheet = false
    @State private var shouldPresentNotesSheet = false
    @State private var friendNotes: String
    
    var friendIndex: Int
    {
        modelData.friends.firstIndex(where: { $0.id == friend.id })!
    }
    
    init(friend: Friend) {
        self.friend = friend
        _friendNotes = State(initialValue: friend.notes)
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        
        ZStack
        {
            BlurredBackground(image: friend.profilePicture)
                .opacity(0.7)
            
            ScrollView
            {
                ZStack
                {
                    friend.profilePicture
                        .resizable()
                        .scaledToFit()
                        .mask(LinearGradient(gradient: Gradient(stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .gray, location: 0.25),
                            .init(color: .black, location: 0.33),
                            .init(color: .black, location: 0.9),
                            .init(color: .clear, location: 1)
                        ]), startPoint: .top, endPoint: .bottom))
                        .padding(.vertical, -25)
                        .offset(y: 10)
                    
                    VStack
                    {
                        HStack
                        {
                            Text(friend.location + ", " + friend.country)
                            Spacer()
                            FavoriteButton(isSet: $modelData.friends[friendIndex].isFavorite)
                        }
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                
                ClockWidget(timeZoneID: friend.timeZoneID)
                    .padding(20)
                
                NotesWidget(notes: $friendNotes)
                    .padding(20)
                    .gesture(TapGesture().onEnded{
                        shouldPresentNotesSheet.toggle()
                    })
                    .sheet(isPresented: $shouldPresentNotesSheet){
                    } content: {
                        ZStack{
                            NotesPage(friendName: friend.name, backgroundImage: friend.profilePicture, notes: $friendNotes)
                                .padding(-1)
                            VStack{
                                ZStack{
                                    Rectangle()
                                        .foregroundStyle(.bar)
                                        .frame(height: 50)
                                    HStack{
                                        Text(friend.name+"'s notes")
                                        Spacer()
                                        Button("Done") { shouldPresentNotesSheet.toggle() }
                                    }
                                    .padding(15)
                                }
                                Spacer()
                            }
                        }
                    }
                
                MapView(coordinate: friend.locationCoordinate)
                    .frame(height: 200)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .gesture(TapGesture().onEnded {
                        shouldPresentMapSheet.toggle()
                    })
                    .sheet(isPresented: $shouldPresentMapSheet){
                    } content: {
                        ZStack{
                            MapView(coordinate: friend.locationCoordinate)
                                .padding(-1)
                            VStack{
                                ZStack{
                                    Rectangle()
                                        .foregroundStyle(.bar)
                                        .frame(height: 50)
                                    HStack{
                                        Text(friend.name+"'s location")
                                        Spacer()
                                        Button("Done") { shouldPresentMapSheet.toggle() }
                                    }
                                    .padding(15)
                                }
                                Spacer()
                            }
                        }
                    }
                
            }
            .navigationTitle(friend.name)
            .navigationBarTitleDisplayMode(.large)
        }
        // TODO: Reenable this after finding a non-deprecated alternative, low priority
        /*.onChange(of: shouldPresentNotesSheet) { newValue in
            if !newValue {
                modelData.saveChanges(friend: friend, index: friendIndex)
            }
        }*/
    }
}

#Preview {
    let modelData = ModelData()
    return FriendDetail(friend: ModelData().friends[1])
        .environment(modelData)
}
