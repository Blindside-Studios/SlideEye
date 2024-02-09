import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        Map(initialPosition: .region(region))
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -10.125, longitude: -72.875),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
    }
}

#Preview {
    MapView()
}
