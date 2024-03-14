import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    var friendName: String
    @Binding var shouldPresentMapSheet: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Map(position: .constant(.region(region)))
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
                    Map(position: .constant(.region(region)))
                        .padding(-1)
                    VStack{
                        ZStack{
                            Rectangle()
                                .foregroundStyle(.bar)
                                .frame(height: 50)
                            HStack{
                                Text(friendName+"'s location")
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
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
    }
}

/*#Preview {
    MapView(coordinate: ModelData().friends[0].locationCoordinate)
}
*/
