import Foundation
import CoreLocation
import MapKit

internal class TWCity: NSObject, Identifiable, Codable {
    let id: UUID = .init()
    let countycode: String
    let countyname: String
    let count: Int64
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.countycode = try container.decode(String.self, forKey: .countycode)
        self.countyname = try container.decode(String.self, forKey: .countyname)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.count = try container.decode(Int64.self, forKey: .count)
    }
    
    static func Loader() -> [TWCity] {
        guard
            let jsonURL = Bundle.main.url(forResource: "City", withExtension: "json"),
            let jsonData = try? Data(contentsOf: jsonURL),
            let result = try? JSONDecoder().decode([TWCity].self, from: jsonData)
        else {
            return []
        }
        return result
    }
}

extension TWCity: MKAnnotation {
    
}
