import SwiftUI

struct AnalogueClock: View 
{
    @Binding var days: Int
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var seconds: Int

    @State private var beginningDays: Int = 0
    @State private var beginningHours: Int = 0
    @State private var beginningMinutes: Int = 0
    
    @State private var isInitialAppear: Bool = true
    @State private var isYetToEntrance: Bool = true
    
    func calculateHourRotation() -> Double
    {
        // add one second because due to animation, clock always lags behind by one second
        let daysPassed = days - beginningDays
        let hoursPassed = hours
        let minutesPassed = minutes
        let secondsPassed = seconds + 1

        let totalHoursPassed = Double(secondsPassed) / 60 / 60 +
                               Double(minutesPassed) / 60 +
                               Double(hoursPassed) +
                               Double(daysPassed) * 24
        
        return Double(totalHoursPassed) / 12 * 360
    }

    func calculateMinuteRotation() -> Double
    {
        let daysPassed = days - beginningDays
        let hoursPassed = hours - beginningHours
        let minutesPassed = minutes
        let secondsPassed = seconds + 1

        let totalMinutesPassed = Double(secondsPassed) / 60 +
                                 Double(minutesPassed) +
                                 Double(hoursPassed) * 60 +
                                 Double(daysPassed) / 2 * 1440

        return Double(totalMinutesPassed) / 60 * 360
    }

    func calculateSecondRotation() -> Double
    {
        let daysPassed = days - beginningDays
        let hoursPassed = hours - beginningHours
        let minutesPassed = minutes - beginningMinutes
        let secondsPassed = seconds + 1

        let totalSecondsPassed = Double(secondsPassed) +
                                 Double(minutesPassed) * 60 +
                                 Double(hoursPassed) * 3600 +
                                 Double(daysPassed) / 2 * 86400

        return Double(totalSecondsPassed) / 60 * 360
    }
    
    var body: some View
    {
        ZStack
        {
            ClockBackground()
                .rotationEffect(Angle(degrees: calculateSecondRotation()))
                .animation(isInitialAppear ? .easeOut(duration: 1.0) : .linear(duration: 1.0), value: calculateSecondRotation())
            
            Group
            {
                ClockHand(handLength: 2, handThickness: 6)
                    .shadow(radius: 5)
                    .rotationEffect(Angle(degrees: calculateHourRotation()))
                    .animation(isInitialAppear ? .easeOut(duration: 1.0) : .linear(duration: 1.0), value: calculateHourRotation())
                ClockHand(handLength: 3, handThickness: 4)
                    .shadow(radius: 5)
                    .rotationEffect(Angle(degrees: calculateMinuteRotation()))
                    .animation(isInitialAppear ? .easeOut(duration: 1.0) : .linear(duration: 1.0), value: calculateMinuteRotation())
                ClockHand(handLength: 20, handThickness: 2)
                    .rotationEffect(Angle(degrees: calculateSecondRotation()))
                    .animation(isInitialAppear ? .easeOut(duration: 1.0) : .linear(duration: 1.0), value: calculateSecondRotation())
                    .onAppear
                    {
                        beginningDays = days
                        beginningHours = hours
                        beginningMinutes = minutes
                        
                        isYetToEntrance = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                            isInitialAppear = false
                    }
                }
            }
            .frame(width: 200, height: 200)
            .opacity(isYetToEntrance ? 0 : 1)
            .scaleEffect(isYetToEntrance ? CGSize(width: 0, height: 0) : CGSize(width: 1.0, height: 1.0))
            .animation(.easeOut(duration: 0.75), value: isYetToEntrance)
        }
        .offset(x: 100)
    }
}

#Preview {
    AnalogueClock(days: .constant(0), hours: .constant(9), minutes: .constant(5), seconds: .constant(20))
}
