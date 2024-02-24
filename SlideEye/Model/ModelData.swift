import Foundation

@Observable
class ModelData
{
    var friends: [Friend] = load("FriendsData.json")
    
    func saveChanges(friend: Friend, index: Int)
    {
        friends[index] = friend
        
        // TODO: Reroute to local storage rather than app files and enable again
        // save("FriendsData.json", friends)
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data


    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }


    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }


    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


func save<T: Encodable>(_ filename: String, _ data: T ){
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) 
    else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: file)
        } catch {
            fatalError("Couldn't write to file \(filename): \(error)")
        }
}
