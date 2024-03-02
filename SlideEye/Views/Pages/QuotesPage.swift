import SwiftUI

struct QuotesPage: View {
    @Environment(ModelData.self) var modelData
    var name: String
    var profilePicture: Image
    var friendID: Int
    @Binding var quotes: [Friend.Quote]
    @Binding var shouldPresentAddNewSheet: Bool
    @Binding var sortByYear: Bool
    
    @State private var addedQuoteText = ""
    @State private var addedQuoteYear = String(Calendar.current.component(.year, from: Date()))
    
    let currentYear = String(Calendar.current.component(.year, from: Date()))
    
    var sortedQuotes: [Friend.Quote] {
        sortByYear ? quotes.reversed().sorted { $0.year > $1.year } : quotes.reversed()
    }
    
    func addFriendToList(quoteText: String, year: Int)
    {
        let newQuote = Friend.Quote(id: Int(String(friendID) + String(quotes.count + 1000)) ?? friendID*10000, text: quoteText, year: year)
        
        quotes.append(newQuote)
        
        // get friend index based on ID
        var friendIndex: Int
        {
            modelData.friends.firstIndex(where: { $0.id == friendID })!
        }
        
        // add quote and save new selection
        modelData.friends[friendIndex].quotes.append(newQuote)
        modelData.saveChanges(friendsList: modelData.friends)
    }
    
    var body: some View {
        ZStack
        {
            BlurredBackground(image: profilePicture)
                .opacity(0.4)
            ScrollView
            {
                VStack(spacing: 10)
                {
                    ForEach(sortedQuotes)
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
        .sheet(isPresented: $shouldPresentAddNewSheet){
        } content: {
            ZStack{
                ScrollView
                {
                    VStack
                    {
                        Text("Quote")
                        TextField("Type your quote here", text: $addedQuoteText)
                        Text("Year of origin")
                        TextField("In which year was this quote said?", text: $addedQuoteYear)
                            .keyboardType(.numberPad)
                        
                    }
                    .padding(.vertical, 35)
                    .offset(y: 35)
                }
                //insert display content
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.bar)
                            .frame(height: 50)
                        HStack{
                            Button("Cancel") { shouldPresentAddNewSheet.toggle(); addedQuoteText=""; addedQuoteYear = currentYear }
                            Spacer()
                            Button("Save") { shouldPresentAddNewSheet.toggle(); addFriendToList(quoteText: addedQuoteText, year: Int(addedQuoteYear) ?? Calendar.current.component(.year, from: Date())); addedQuoteText=""; addedQuoteYear=currentYear }
                        }
                        .padding(.horizontal, 15)
                    }
                    Spacer()
                }
                .shadow(radius: 5)
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
