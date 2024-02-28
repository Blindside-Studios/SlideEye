import Foundation

@Observable
class ModelData
{
    var friends: [Friend] = load("FriendsData.json") // this should read an equivalent file from local storage
    
    func saveChanges(friendsList: [Friend])
    {
        save("FriendsData.json", friends)
    }
    
    func loadExampleFriends()
    {
        friends = loadHardcoded("FriendsData.json")
        saveChanges(friendsList: friends)
    }
    
    func deleteAllFriends()
    {
        let fileName = "FriendsData.json"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent(fileName)

        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            fatalError("Couldn't delete file \(fileName): \(error)")
        }
    }
}

func loadHardcoded<T: Decodable>(_ filename: String) -> T {
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


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentDirectory.appendingPathComponent(filename)

    // Check if the file exists
    guard FileManager.default.fileExists(atPath: fileURL.path) else {
        // If the file does not exist and the type is an array of Friends, return an empty array
        if T.self == [Friend].self {
            return [] as! T
        }
        fatalError("File \(filename) does not exist.")
    }

    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        fatalError("Couldn't load \(filename) from documents directory:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


func save<T: Encodable>(_ filename: String, _ data: T) {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentDirectory.appendingPathComponent(filename)

    do {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(data)
        try jsonData.write(to: fileURL)
    } catch {
        fatalError("Couldn't write to file \(filename): \(error)")
    }
}

