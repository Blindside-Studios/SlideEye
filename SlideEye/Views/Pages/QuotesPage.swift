import SwiftUI

struct QuotesPage: View {
    @Environment(ModelData.self) var modelData
    var name: String
    var profilePicture: Image
    @Binding var quotes: [Friend.Quote]
    
    var body: some View {
        ZStack
        {
            BlurredBackground(image: profilePicture)
                .opacity(0.4)
            ScrollView
            {
                VStack(spacing: 10)
                {
                    ForEach(quotes)
                    { quote in
                        QuotesWidget(name: name, quote: quote, profilePicture: profilePicture)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .shadow(radius: 10)
                    }
                }
                .padding(.vertical, 35)
                .offset(y: 35)
            }
        }
    }
}

/*#Preview {
    QuotesPage(
        name: "name",
        profilePicture: Image("1001"),
        quotes: .constant(modelData.friends[0].quotes)
    )
}*/
