import SwiftUI

struct FriendDetail: View {
    var friend: Friend
    
    @State var shouldPresentMapSheet = false
    
    var body: some View {
        GeometryReader 
        { geometry in
            ScrollView
            {
                FalloffImage(image: friend.profilePicture)
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: 0.75),
                        .init(color: .clear, location: 1)
                    ]), startPoint: .top, endPoint: .bottom))
                    .padding(-60)
                    .frame(height: 230)
                Spacer(minLength: 70)
                VStack(alignment: .leading) 
                {
                    Text(friend.name)
                        .font(.largeTitle)
                    HStack 
                    {
                        Text(friend.location)
                            .font(.subheadline)
                        Spacer()
                        Text(friend.country)
                            .font(.title2)
                    }
                }
                .padding()
                
                MapView(coordinate: friend.locationCoordinate)
                .frame(height: 200)
                .cornerRadius(25)
                .padding(10)
                .gesture(TapGesture().onEnded {
                    shouldPresentMapSheet.toggle()
                })
                .sheet(isPresented: $shouldPresentMapSheet){
                    print("Sheet dimissed!")
                } content: {
                    ZStack{
                        MapView(coordinate: friend.locationCoordinate)
                            .padding(-1)
                        VStack{
                            ZStack{
                                Rectangle()
                                    .background(.ultraThinMaterial)
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
                
                VStack(alignment: .leading) 
                {
                    HStack
                    {
                        Text("Notes")
                            .font(.headline)
                        Spacer()
                    }
                    Text(friend.notes)
                        .font(.caption)
                    
                    ForEach(1...20, id: \.self) { index in
                        Text("Test Item \(index)")
                            .padding()
                    }
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    FriendDetail(friend: friends[0])
}
