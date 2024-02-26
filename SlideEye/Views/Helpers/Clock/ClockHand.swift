import SwiftUI

struct ClockHandShape: Shape {
    var ratio: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let end = CGPoint(x: center.x, y: center.y - rect.width / 2 * ratio)

        path.move(to: center)
        path.addLine(to: end)
        
        return path
    }
}

struct ClockHand: View {
    var handLength: Int
    var handThickness: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ClockHandShape(ratio: CGFloat(handLength))
            .stroke( colorScheme == .dark ? Color.white: Color.black, style: StrokeStyle(lineWidth: CGFloat(handThickness), lineCap: .round, lineJoin: .round))
            .frame(width: 50, height: 50)
    }
}

#Preview {
    ClockHand(handLength: 2, handThickness: 7)
}
