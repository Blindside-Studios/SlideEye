import SwiftUI

struct QuotesPage: View {
    @Environment(ModelData.self) var modelData
    var name: String
    var profilePicture: Image
    @Binding var quotes: [Friend.Quote]
    
    var body: some View {
        List
        {
            ForEach(quotes)
            { quote in
                NavigationLink {
                    //FriendDetail(friend: friend)
                } label: {
                    Text("(\(quote.year)) \(quote.text)")
                }
            }
        }
        .padding(.vertical, 45)
        .offset(y: 45)
    }
}

/*#Preview {
    QuotesPage(
        name: "name",
        profilePicture: Image("1001"),
        quotes: .constant(modelData.friends[0].quotes)
    )
}*/
