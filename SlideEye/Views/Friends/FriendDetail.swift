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
    
    // for QuotesPage
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
                            .shadow(radius: 5)
                        }
                    }
                
                QuotesWidget(name: friend.name, quote: friend.quotes[0], profilePicture: friend.profilePicture, useTransparency: true)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .shadow(radius: 10)
                    .gesture(TapGesture().onEnded {
                        shouldPresentQuotesSheet.toggle()
                    })
                    .sheet(isPresented: $shouldPresentQuotesSheet){
                    } content: {
                        ZStack{
                            QuotesPage(name: friend.name, profilePicture: friend.profilePicture, friendID: friend.id, quotes: $friendQuotes, shouldPresentAddNewSheet: $shouldPresentAddNewQuoteSheet, sortByYear: $sortQuotesByYear)
                                .padding(-1)
                            VStack{
                                ZStack{
                                    Rectangle()
                                        .foregroundStyle(.bar)
                                        .frame(height: 50)
                                    HStack{
                                        Text(friend.name+"'s quotes")
                                        Spacer()
                                        QuoteSortButton(sortByYear: $sortQuotesByYear)
                                        Button(action: {
                                            shouldPresentAddNewQuoteSheet.toggle()
                                        }, label: {
                                            Image(systemName: "plus")
                                                .padding(.horizontal, 5)
                                                .padding(.vertical, 10)
                                        })
                                        Button("Done") { shouldPresentQuotesSheet.toggle() }
                                    }
                                    .padding(.horizontal, 15)
                                }
                                Spacer()
                            }
                            .shadow(radius: 5)
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
                            .shadow(radius: 5)
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
    return FriendDetail(friend: ModelData().friends[0])
        .environment(modelData)
}
