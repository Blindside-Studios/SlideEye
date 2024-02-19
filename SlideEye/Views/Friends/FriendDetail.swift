import SwiftUI

struct FriendDetail: View {
    @Environment(ModelData.self) var modelData // this line makes the preview crash
    var friend: Friend
    
    @State private var shouldPresentMapSheet = false
    
    var friendIndex: Int
    {
        modelData.friends.firstIndex(where: { $0.id == friend.id })!
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
                            Spacer()
                            FavoriteButton(isSet: $modelData.friends[friendIndex].isFavorite)
                        }
                        .font(.title2)
                        .padding(.horizontal)
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading)
                {
                    ZStack
                    {
                        Rectangle()
                            .frame(height: 200)
                            .background(.regularMaterial)
                            .cornerRadius(25)
                        
                        Group
                        {
                            VStack
                            {
                                Text("Notes")
                                    .font(.headline)
                                    .frame(alignment: .leading)
                                Text(friend.notes)
                                    .font(.caption)
                                    .frame(alignment: .leading)
                            }
                        }
                    }
                }
                .padding(20)
                
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
    }
}

#Preview {
    let modelData = ModelData()
    return FriendDetail(friend: ModelData().friends[1])
        .environment(modelData)
}
