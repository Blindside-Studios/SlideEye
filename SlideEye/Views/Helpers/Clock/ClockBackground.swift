import SwiftUI

struct ClockBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {            
            Circle()
                .trim(from: 0, to: 1)
                .stroke(AngularGradient(gradient: Gradient(colors: [ Color.clear, colorScheme == .dark ?  Color.black: Color.white]), center: .center), lineWidth: 350)
                .frame(width: 350, height: 350)
                .rotationEffect(Angle(degrees: 270))
                .opacity(colorScheme == .dark ? 0.8: 1)
                }
    }
}
#Preview {
    ClockBackground()
}
