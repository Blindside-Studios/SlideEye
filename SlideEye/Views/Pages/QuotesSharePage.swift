import SwiftUI

struct QuotesSharePage: View {
    var name: String
    @Binding var quote: Friend.Quote
    var profilePicture: Image
    
    var body: some View {
        VStack{
            let widget = QuotesWidget(name: name, quote: quote, profilePicture: profilePicture, useTransparency: false).frame(width: 400, height: 200)
            widget

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
