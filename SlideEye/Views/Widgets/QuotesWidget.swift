import SwiftUI

struct QuotesWidget: View {
    @Environment(ModelData.self) var modelData
    @Environment(\.colorScheme) var colorScheme
    
    var name: String
    var quote: Friend.Quote
    var profilePicture: Image
    var useTransparency: Bool
    var friend: Friend
    @Binding var friendQuotes: [Friend.Quote]
    @Binding var shouldPresentQuotesSheet: Bool
    @Binding var shouldPresentAddNewQuoteSheet: Bool
    @Binding var sortQuotesByYear: Bool
    var allowSheet: Bool
    
    @State var textBoxHeight: CGFloat = 0
    
    var body: some View {
        ZStack
        {
            if (useTransparency)
            {
                Rectangle()
                    .frame(height: 200)
                    .background(.regularMaterial)
                    .brightness(colorScheme == .dark ? -0.3: 0.4)
            }
            
            else
            {
                BlurredBackground(image: profilePicture)
                    .frame(height: 200)
            }
            
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
                ZStack(alignment: .leading)
                {
                    HStack
                    {
                        Image(systemName: "quote.opening")
                            .resizable()
                            .frame(width: 75, height: 50)
                            .opacity(0.25)
                            .offset(y: -(textBoxHeight-20)/2)
                        Spacer()
                        Image(systemName: "quote.closing")
                            .resizable()
                            .frame(width: 75, height: 50)
                            .opacity(0.25)
                            .offset(y: (textBoxHeight-50)/2)
                    }
                    .padding(10)
                    .offset(x: -10)
                    
                    VStack
                    {
                        Text(quote.text)
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(alignment: .trailing)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .offset(x: -10, y: 5)
                            .shadow(radius: 2)
                            .minimumScaleFactor(0.5)
                            .background(GeometryReader { geometry in
                                                    Color.clear.onAppear {
                                                        self.textBoxHeight = geometry.size.height
                                                    }
                                                })
                        
                        HStack
                        {
                            Spacer()
                            Text("\(name), \(String(format: "%d",quote.year))")
                                .font(.subheadline)
                                .shadow(radius: 3)
                                .padding(.horizontal, 20)
                                .offset(x: -10)
                        }
                    }
                    .frame(height: 180)
                    .padding(.vertical, 10)
                    .offset(y: -5)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .shadow(radius: 10)
        .gesture(TapGesture().onEnded {
            if (allowSheet) { shouldPresentQuotesSheet.toggle() }
        })
        .sheet(isPresented: $shouldPresentQuotesSheet){
        } content: {
            ZStack{
                QuotesPage(name: friend.name, profilePicture: friend.profilePicture, friendID: friend.id, quotes: $friendQuotes, shouldPresentAddNewSheet: $shouldPresentAddNewQuoteSheet, sortByYear: $sortQuotesByYear, isShown: $shouldPresentQuotesSheet)
                    .padding(-1)
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.bar)
                            .frame(height: 50)
                        HStack{
                            Text(friend.name+"'s quotes")
                            Spacer()
                            QuoteSortButton(sortByYear: $sortQuotesByYear)
                            Button(action: {
                                shouldPresentAddNewQuoteSheet.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 10)
                            })
                            Button("Done") { shouldPresentQuotesSheet.toggle() }
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

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view!.bounds = CGRect(origin: .zero, size: targetSize)
        view!.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view!.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}


/*#Preview {
    QuotesWidget(name: "Lara Croft", quote: Friend.Quote(id: 00000, text: "fheuw ferw gre fgre fer wqef ewfewfewfewf ewf ew few fewfewfewf fewewfwef ewfewf ewf ewfewfewfew ewfewfewfew", year: 2018), profilePicture: Image("1001_00"), useTransparency: false)
}*/
