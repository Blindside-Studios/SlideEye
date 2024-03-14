import SwiftUI
import Foundation

struct ClockWidget: View {
    var timeZoneID: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var timeZone: TimeZone? {
        return TimeZone(identifier: timeZoneID)
    }
    
    @State private var year: Int = 0
    @State private var month: Int = 0
    @State private var day: Int = 0
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var second: Int = 0
    @State private var dayOfWeek: Int = 1
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var dayOfWeekNames: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack
        {
            Rectangle()
                .background(.regularMaterial)
                .brightness(colorScheme == .dark ? -0.25: 0.3)
            
            AnalogueClock(days: $day, hours: $hour, minutes: $minute, seconds: $second)
                .frame(height: 200)
            
            HStack
            {
                VStack
                {
                    Text("\(hour):\(String(format: "%02d", minute))")
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .shadow(radius: 5)
                        .onAppear{
                            setDateComponents()
                        }
                        .onReceive(timer) { _ in
                            setDateComponents()
                        }
                    Text("\(dayOfWeekNames[dayOfWeek-1]), \(month)/\(day)/\(String(format: "%d", year))")
                        .font(.title3)
                        .shadow(radius: 5)
                }
                .frame(alignment: .trailing)
                .padding(.vertical, 20)
                Spacer()
            }
            .padding()
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .shadow(radius: 10)
    }
    
    func setDateComponents() {
        guard let timeZone = timeZone else { print("Could not find time zone"); return }
        
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .weekday], from: date)
        
        if let year = components.year,
           let month = components.month,
           let day = components.day,
           let hour = components.hour,
           let minute = components.minute,
           let second = components.second,
           let weekday = components.weekday {
            self.year = year
            self.month = month
            self.day = day
            self.hour = hour
            self.minute = minute
            self.second = second
            self.dayOfWeek = weekday
        }
    }
}

#Preview {
    ClockWidget(timeZoneID: "Europe/Rome")
}
