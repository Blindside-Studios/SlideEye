import SwiftUI

struct QuotesWidget: View {
    var name: String
    var quote: Friend.Quote
    var profilePicture: Image
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack
        {
            Rectangle()
                .frame(height: 200)
                .background(.regularMaterial)
                .brightness(colorScheme == .dark ? -0.3: 0.4)
            HStack
            {
                profilePicture
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFit()
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: 0.5),
                        .init(color: .clear, location: 1)
                    ]), startPoint: .leading, endPoint: .trailing))
                    .offset(x: -25)
                    .saturation(colorScheme == .dark ? 1: 0.1)
                Spacer()
            }
            HStack
            {
                Spacer()
                    .frame(width: 120)
                VStack
                {
                    Text(quote.text)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center
                        )
                        .padding(.vertical, 10)
                        .offset(y: 5)
                        .shadow(radius: 1)
                    
                    HStack
                    {
                        Spacer()
                        Text("\(name), \(String(format: "%d",quote.year))")
                            .font(.subheadline)
                            .shadow(radius: 1)
                    }
                }
                .frame(height: 170)
                .padding(10)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

#Preview {
    QuotesWidget(name: "Lara Croft", quote: Friend.Quote(text: "Fuck you, Rourke!", year: 2018), profilePicture: Image("1001"))
}
