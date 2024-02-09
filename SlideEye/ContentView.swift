import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                FalloffImage()
                    .mask(LinearGradient(gradient: Gradient(stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.75),
                            .init(color: .clear, location: 1)
                          ]), startPoint: .top, endPoint: .bottom))
                    .padding(-60)
                    .frame(height: 200)
                Spacer(minLength: 70)
                VStack(alignment: .leading) {
                    Text("Lara Croft")
                        .font(.largeTitle)
                    HStack {
                        Text("Paititi")
                            .font(.subheadline)
                        Spacer()
                        Text("Peru")
                            .font(.subheadline)
                    }
                }
                .padding()
                MapView()
                    .frame(height: 300)
                    .cornerRadius(25)
                    .padding(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
