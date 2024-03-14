import SwiftUI

struct QuotesPage: View {
    @Environment(ModelData.self) var modelData
    var name: String
    var profilePicture: Image
    var friendID: Int
    @Binding var quotes: [Friend.Quote]
    @Binding var shouldPresentAddNewSheet: Bool
    @Binding var sortByYear: Bool
    @Binding var isShown: Bool
    
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
    
    @State private var isShowingShareSheet = false
    @State private var selectedQuote = Friend.Quote(id: 0000, text: "Quote", year: 0)
    
    func renderQuote(quote: Friend.Quote){
        selectedQuote = quote
        isShowingShareSheet.toggle()
    }
    
    var body: some View {
        ZStack
        {
            BlurredBackground(image: profilePicture)
                .opacity(0.4)
            ScrollView
            {
                LazyVStack(spacing: 10)
                {
                    ForEach(sortedQuotes)
                    { quote in
                        QuotesWidget(name: name, quote: quote, profilePicture: profilePicture, useTransparency: true, friend: Friend(id: 000, quotes: []), friendQuotes: .constant([Friend.Quote(id: 0, text: "qwerty", year: 0000)]), shouldPresentQuotesSheet: .constant(false), shouldPresentAddNewQuoteSheet: .constant(false), sortQuotesByYear: .constant(false), allowSheet: false)
                            .transition(.asymmetric(insertion: .slide, removal: .slide))
                            .contextMenu {
                                Button {
                                    renderQuote(quote: quote)
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                Divider()
                                Button(role: .destructive, action: {
                                    quotes.removeAll { $0.id == quote.id }
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .animation(.bouncy(duration: 0.5), value: sortedQuotes)
                .padding(.vertical, 35)
                .offset(y: 35)
            }
            .sheet(isPresented: $shouldPresentAddNewSheet){
            } content: {
                ZStack{
                    List
                    {
                        Section("Quote"){
                            TextField("Type your quote here", text: $addedQuoteText)
                        }
                        Section("Year"){
                            TextField("In which year was this quote said?", text: $addedQuoteYear)
                                .keyboardType(.numberPad)
                        }
                        
                    }
                    .padding(.vertical, 35)
                    .offset(y: 35)
                    
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
            .sheet(isPresented: $isShowingShareSheet){
            } content: {
                QuotesSharePage(name: name, quote: $selectedQuote, profilePicture: profilePicture)
            }
        }
    }
}

#Preview {
 let modelData = ModelData()
    return QuotesPage(name: "Lara Croft", profilePicture: Image("1001_00"), friendID: modelData.friends[0].id, quotes: .constant(modelData.friends[0].quotes), shouldPresentAddNewSheet: .constant(false), sortByYear: .constant(false), isShown: .constant(true))
     .environment(modelData)
}
