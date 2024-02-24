import Foundation
import SwiftUI
import CoreLocation

struct Friend: Hashable, Codable, Identifiable{
    
    // basic information
    var id: Int
    var name: String
    var occupation: String
    var location: String
    var city: String // closeby city
    var country: String
    var continent: String
    var timeZoneID: String
    var isFavorite: Bool
    var notes: String
    
    // the profile picture
    private var imageName: String
    var profilePicture: Image {
        Image(imageName)
    }
    
    // location
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(
                latitude: coordinates.latitude,
                longitude: coordinates.longitude)
        }
    
    // location structure
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
