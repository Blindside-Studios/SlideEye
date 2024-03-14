import SwiftUI

struct FriendDetail: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.colorScheme) var colorScheme
    var friend: Friend
    
    @State private var shouldPresentMapSheet = false
    @State private var shouldPresentNotesSheet = false
    @State private var shouldPresentQuotesSheet = false
    @State private var friendNotes: String
    @State private var friendQuotes: [Friend.Quote]
    
    @State private var shouldPresentAddNewQuoteSheet: Bool
    @State private var sortQuotesByYear: Bool
    
    var friendIndex: Int
    {
        modelData.friends.firstIndex(where: { $0.id == friend.id })!
    }
    
    init(friend: Friend) {
        self.friend = friend
        _friendNotes = State(initialValue: friend.notes)
        _friendQuotes = State(initialValue: friend.quotes)
        
        _shouldPresentAddNewQuoteSheet = State(initialValue: false)
        //TODO: load sortQuotesByYear from user preferences
        _sortQuotesByYear = State(initialValue: false)
    }
    
    func updateFriendsList(){
        modelData.friends[friendIndex] = friend
        modelData.friends[friendIndex].notes = friendNotes
        modelData.saveLocalChanges()
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        
        ZStack
        {
            BlurredBackground(image: friend.profilePicture)
            
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
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                
                ClockWidget(timeZoneID: friend.timeZoneID)
                
                NotesWidget(friendName: friend.name, profilePicture: friend.profilePicture, notes: $friendNotes, shouldPresentNotesSheet: $shouldPresentNotesSheet)
                
                QuotesWidget(name: friend.name, quote: friend.quotes[0], profilePicture: friend.profilePicture, useTransparency: true, friend: friend, friendQuotes: $friendQuotes, shouldPresentQuotesSheet: $shouldPresentQuotesSheet, shouldPresentAddNewQuoteSheet: $shouldPresentAddNewQuoteSheet, sortQuotesByYear: .constant(false), allowSheet: true)
                
                MapView(coordinate: friend.locationCoordinate, friendName: friend.name, shouldPresentMapSheet: $shouldPresentMapSheet)
                
            }
            .navigationTitle(friend.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    FavoriteButton(isSet: $modelData.friends[friendIndex].isFavorite)
                }
            }
            .onChange(of: modelData.friends[friendIndex].isFavorite, {
                modelData.saveLocalChanges()
            })
            .onChange(of: friendNotes, {
                modelData.friends[friendIndex].notes = friendNotes
                modelData.saveLocalChanges()
            })
            .onChange(of: friendQuotes, {
                modelData.friends[friendIndex].quotes = friendQuotes
                modelData.saveLocalChanges()})
        }
    }
}

#Preview {
    let modelData = ModelData()
    return FriendDetail(friend: ModelData().friends[0])
        .environment(modelData)
}
