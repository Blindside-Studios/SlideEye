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
    
    @State private var isShareSheetShowing = false
    @State private var shareItems: [Any] = []
    
    @MainActor func exportQuote(quote: Friend.Quote) {
        let view = QuotesWidget(name: name, quote: quote, profilePicture: profilePicture, useTransparency: false).frame(width: 500, height: 200)
        
        let renderer = ImageRenderer(content: view)
        
        if let uiImage = renderer.uiImage {
            
            if let data = uiImage.pngData() {
                shareItems = [data]
                isShareSheetShowing = true
            }
        }
    }
    
    func getTopViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first?.rootViewController {
            return topController
        }
        return nil
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
                        QuotesWidget(name: name, quote: quote, profilePicture: profilePicture, useTransparency: true)
                            .padding(.horizontal)
                            .frame(height: 200)
                            .shadow(radius: 10)
                            .contextMenu {
                                Button {
                                    exportQuote(quote: quote)
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                Divider()
                                Button(role: .destructive, action: {
                                    // TODO: Add deleting
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .listStyle(.plain)
                    .animation(.bouncy(duration: 0.5), value: sortedQuotes)
                }
                .padding(.vertical, 35)
                .offset(y: 35)
                .sheet(isPresented: $isShareSheetShowing) {
                    ShareSheet(activityItems: shareItems)
                }
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
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Update the controller if needed.
    }
}


#Preview {
 let modelData = ModelData()
    return QuotesPage(name: "Lara Croft", profilePicture: Image("1001_00"), friendID: modelData.friends[0].id, quotes: .constant(modelData.friends[0].quotes), shouldPresentAddNewSheet: .constant(false), sortByYear: .constant(false))
     .environment(modelData)
}
