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
    var isPinned: Bool
    var notes: String
    
    // the profile picture
    private var imageName: String
    var profilePicture: Image {
        loadImage(imageName: imageName) ?? Image(systemName: "wrongwaysign")
    }
    
    func loadImage(imageName: String) -> Image? {
        let filename = getDocumentsDirectory().appendingPathComponent(imageName)
        if let uiImage = UIImage(contentsOfFile: filename.path) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
    
    
    var quotes: [Quote]
    
    public struct Quote: Hashable, Codable, Identifiable {
        var id: Int
        var text: String
        var year: Int
    }
}

extension Friend {
    init(id: Int, quotes: [Quote]) {
        self.id = id
        self.name = ""
        self.occupation = ""
        self.location = ""
        self.city = ""
        self.country = ""
        self.continent = ""
        self.timeZoneID = ""
        self.isFavorite = false
        self.isPinned = false
        self.notes = ""
        self.imageName = ""
        self.coordinates = Coordinates(latitude: 0, longitude: 0)
        self.quotes = quotes
    }
}

extension Friend {
    init (id: Int, name: String, occupation: String, location: String, city: String, country: String, continent: String, timeZoneID: String, isFavorite: Bool, notes: String, imageName: String){
        self.id = id
        self.name = name
        self.occupation = occupation
        self.location = location
        self.city = city
        self.country = country
        self.continent = continent
        self.timeZoneID = timeZoneID
        self.isFavorite = isFavorite
        self.isPinned = false
        self.notes = notes
        self.imageName = imageName
        self.coordinates = Coordinates(latitude: 0, longitude: 0)
        self.quotes = [Quote(id: 100, text: "Tap the plus at the top to get started adding your own quotes", year: 2077)]
    }
}
