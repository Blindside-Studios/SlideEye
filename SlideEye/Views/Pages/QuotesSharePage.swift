import SwiftUI

struct QuotesSharePage: View {
    var name: String
    @Binding var quote: Friend.Quote
    var profilePicture: Image
    
    func sharePNGImage(_ view: some View, filename: String, subject: String, message: String) {
        /*let image = view.snapshot()
        if let pngData = image.pngData() {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(filename).png")
            do {
                try pngData.write(to: url)
                let items: [Any] = [url]
                let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
                controller.setValue(subject, forKey: "subject")
                controller.setValue(message, forKey: "message")
                UIApplication.shared.windows.first?.rootViewController?.present(controller, animated: true, completion: nil)
            } catch {
                print("Failed to save image:", error.localizedDescription)
            }
        } else {
            print("Failed to convert image to PNG data")
        }*/
    }
    
    var body: some View {
        VStack{
            let widget = QuotesWidget(name: name, quote: quote, profilePicture: profilePicture, useTransparency: false, friend: Friend(id: 000, quotes: []), friendQuotes: .constant([Friend.Quote(id: 0, text: "qwerty", year: 0)]), shouldPresentQuotesSheet: .constant(false), shouldPresentAddNewQuoteSheet: .constant(false), sortQuotesByYear: .constant(false), allowSheet: false).frame(width: 400, height: 200)
            
            widget
            
            Button(action: {sharePNGImage(widget,
                                          filename: "MyPreciousView",
                                          subject: "Exported quote",
                                          message: "Exported quote from \(name) in \(quote.year)")
            }, label: {
                Text("NewShareOption")
            })
            
            let image = widget.snapshot()
            let data = image.pngData()
            ShareLink(
                item: data!,
                subject: Text("Exported quote"),
                message: Text("Exported quote from \(name) in \(quote.year)"),
                preview: SharePreview("\(name) in \(quote.year): '\(quote.text)'", image: data!),
                label: { Label("Share", systemImage: "square.and.arrow.up") })
        }
    }
}

/*#Preview {
    QuotesSharePage()
}*/
