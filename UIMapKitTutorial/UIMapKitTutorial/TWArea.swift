import Foundation
import CoreLocation
import MapKit

internal class TWArea: NSObject, Identifiable, Codable {
    let id: UUID = .init()
    let towncode: String
    let countycode: String
    let townname: String
    let latitude: Double
    let longitude: Double
    let count: Int64
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countycode = try container.decode(String.self, forKey: .countycode)
        self.towncode = try container.decode(String.self, forKey: .towncode)
        self.townname = try container.decode(String.self, forKey: .townname)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.count = try container.decode(Int64.self, forKey: .count)
    }
    
    static func Loader() -> [TWArea] {
        guard
            let jsonURL = Bundle.main.url(forResource: "Area", withExtension: "json"),
            let jsonData = try? Data(contentsOf: jsonURL),
            let result = try? JSONDecoder().decode([TWArea].self, from: jsonData)
        else {
            return []
        }
        return result
    }
}

extension TWArea: MKAnnotation {
    
}
