
import Foundation

public protocol DAWAAddressProtol {

    var street: String { get }
    var streetNumber: String { get }
    var zipCode: String { get }
    var city: String { get }
    var latitude: Double { get }
    var longitude: Double { get }

    var readableAddress: String { get }
}

public struct DAWAAdgangsadresse: DAWAAddressProtol, Decodable {

    public var street: String = ""
    public var streetNumber: String = ""
    public var zipCode: String = ""
    public var city: String = ""
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0

    public var readableAddress: String { return "\(self.street) \(self.streetNumber), \(self.zipCode) \(self.city)" }

    enum CodingKeys: String, CodingKey {
        case street = "vejstykke"
        case streetNumber = "husnr"
        case zipCode = "postnummer"
        case accessPoint = "adgangspunkt"
    }

    enum VejstykkeKeys: String, CodingKey {
        case name = "navn"
    }

    enum PostnummerKeys: String, CodingKey {
        case number = "nr"
        case name = "navn"
    }

    enum AdgangspunktKeys: String, CodingKey {
        case coordinates = "koordinater"
    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        let streetInfo = try values.nestedContainer(keyedBy: VejstykkeKeys.self, forKey: .street)
        self.street = try streetInfo.decode(String.self, forKey: .name)

        self.streetNumber = try values.decode(String.self, forKey: .streetNumber)

        let zipCodeInfor = try values.nestedContainer(keyedBy: PostnummerKeys.self, forKey: .zipCode)
        self.zipCode = try zipCodeInfor.decode(String.self, forKey: .number)
        self.city = try zipCodeInfor.decode(String.self, forKey: .name)

        let accessPointInfo = try values.nestedContainer(keyedBy: AdgangspunktKeys.self, forKey: .accessPoint)
        let coordinates = try accessPointInfo.decode([Double].self, forKey: .coordinates)
        self.latitude = coordinates[0]
        self.longitude = coordinates[1]
    }

}

public struct DAWAAdresse: DAWAAddressProtol, Decodable {

    public var street: String = ""
    public var _streetNumber: String = ""
    public var floor: String? = nil
    public var door: String? = nil
    public var zipCode: String = ""
    public var city: String = ""
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0

    public var streetNumber: String {
        var streetNumber = "\(self.street) \(self._streetNumber)"
        if let floor = self.floor, let door = self.door { streetNumber += ", \(floor). \(door)" }
        else if let floor = self.floor { streetNumber += ", \(floor)." }
        else if let door = self.door { streetNumber += ", \(door)." }
        return streetNumber
    }

    public var readableAddress: String {
        var readableAddress = "\(self.street) \(self._streetNumber)"
        if let floor = self.floor, let door = self.door { readableAddress += ", \(floor). \(door)" }
        else if let floor = self.floor { readableAddress += ", \(floor)." }
        else if let door = self.door { readableAddress += ", \(door)." }
        readableAddress += ", \(self.zipCode) \(self.city)"
        return readableAddress
    }

    enum CodingKeys: String, CodingKey {
        case floor = "etage"
        case door = "dør"
        case accessAddress = "adgangsadresse"

        enum AccessAddressKeys: String, CodingKey {

            case road = "vejstykke"
            case streetNumber = "husnr"
            case zipCode = "postnummer"
            case accessPoint = "adgangspunkt"

            enum VejstykkeKeys: String, CodingKey {
                case name = "navn"
            }

            enum PostnummerKeys: String, CodingKey {
                case number = "nr"
                case name = "navn"
            }

            enum AdgangspunktKeys: String, CodingKey {
                case coordinates = "koordinater"
            }
        }
    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.floor = try? values.decode(String.self, forKey: .floor)
        self.door = try? values.decode(String.self, forKey: .door)

        let accessAddressInfo = try values.nestedContainer(keyedBy: CodingKeys.AccessAddressKeys.self, forKey: .accessAddress)
        let roadInfo = try accessAddressInfo.nestedContainer(keyedBy: CodingKeys.AccessAddressKeys.VejstykkeKeys.self, forKey: .road)

        self.street = try roadInfo.decode(String.self, forKey: .name)
        self._streetNumber = try accessAddressInfo.decode(String.self, forKey: .streetNumber)

        let zipCodeInfo = try accessAddressInfo.nestedContainer(keyedBy: CodingKeys.AccessAddressKeys.PostnummerKeys.self, forKey: .zipCode)
        self.zipCode = try zipCodeInfo.decode(String.self, forKey: .number)
        self.city = try zipCodeInfo.decode(String.self, forKey: .name)

        let accessPointInfo = try accessAddressInfo.nestedContainer(keyedBy: CodingKeys.AccessAddressKeys.AdgangspunktKeys.self, forKey: .accessPoint)
        let coordinates = try accessPointInfo.decode([Double].self, forKey: .coordinates)
        self.latitude = coordinates[0]
        self.longitude = coordinates[1]
    }

}
