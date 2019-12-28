
import Foundation

public struct DAWAAddress: Decodable {

    public var road: String = ""
    public var roadNumber: String = ""
    public var zipCode: String = ""
    public var city: String = ""
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0

    public var readableAddress: String { return "\(self.road) \(self.roadNumber), \(self.zipCode) \(self.city)" }

    enum CodingKeys: String, CodingKey {
        case vejstykke
        case roadNumber = "husnr"
        case postnummer
        case adgangspunkt
    }

    enum VejstykkeKeys: String, CodingKey {
        case navn
    }

    enum PostnummerKeys: String, CodingKey {
        case nr
        case navn
    }

    enum AdgangspunktKeys: String, CodingKey {
        case koordinater
    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        let vejstykkeInfo = try values.nestedContainer(keyedBy: VejstykkeKeys.self, forKey: .vejstykke)
        self.road = try vejstykkeInfo.decode(String.self, forKey: .navn)

        self.roadNumber = try values.decode(String.self, forKey: .roadNumber)

        let postnummerInfo = try values.nestedContainer(keyedBy: PostnummerKeys.self, forKey: .postnummer)
        self.zipCode = try postnummerInfo.decode(String.self, forKey: .nr)
        self.city = try postnummerInfo.decode(String.self, forKey: .navn)

        let adgangspunktInfo = try values.nestedContainer(keyedBy: AdgangspunktKeys.self, forKey: .adgangspunkt)
        let coordinates = try adgangspunktInfo.decode([Double].self, forKey: .koordinater)
        self.latitude = coordinates[0]
        self.longitude = coordinates[1]
    }
}
