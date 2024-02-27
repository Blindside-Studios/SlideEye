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
    @State private var firstFriendQuote: Friend.Quote
    
    var friendIndex: Int
    {
        modelData.friends.firstIndex(where: { $0.id == friend.id })!
    }
    
    init(friend: Friend) {
        self.friend = friend
        _friendNotes = State(initialValue: friend.notes)
        _friendQuotes = State(initialValue: friend.quotes)
        _firstFriendQuote = State(initialValue: friend.quotes[0])
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
                            FavoriteButton(isSet: $modelData.friends[friendIndex].isFavorite)
                        }
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                
                ClockWidget(timeZoneID: friend.timeZoneID)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .shadow(radius: 10)
                
                NotesWidget(notes: $friendNotes)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .shadow(radius: 10)
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
                
                QuotesWidget(name: friend.name, quote: $firstFriendQuote, profilePicture: friend.profilePicture)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .shadow(radius: 10)
                    .gesture(TapGesture().onEnded {
                        shouldPresentQuotesSheet.toggle()
                    })
                    .sheet(isPresented: $shouldPresentQuotesSheet){
                    } content: {
                        ZStack{
                            QuotesPage(name: friend.name, profilePicture: friend.profilePicture, quotes: $friendQuotes)
                                .padding(-1)
                            VStack{
                                ZStack{
                                    Rectangle()
                                        .foregroundStyle(.bar)
                                        .frame(height: 50)
                                    HStack{
                                        Text(friend.name+"'s quotes")
                                        Spacer()
                                        Button("Done") { shouldPresentQuotesSheet.toggle() }
                                    }
                                    .padding(.horizontal, 15)
                                }
                                Spacer()
                            }
                        }
                    }
                
                MapView(coordinate: friend.locationCoordinate)
                    .frame(height: 200)
                    .cornerRadius(25)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .shadow(radius: 10)
                    .saturation( colorScheme == .dark ?  0.7: 0.1)
                    .opacity(0.85)
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
                                    .padding(.horizontal, 15)
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
