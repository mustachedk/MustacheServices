
import Foundation

public struct AutoCompleteModel: Decodable {

    public let type: AutoCompleteType
    public let tekst: String
    public let forslagsTekst: String
    public let caretPosition: Int
    public let href: String

    enum CodingKeys: String, CodingKey {
        case type
        case tekst
        case forslagsTekst = "forslagstekst"
        case caretPosition = "caretpos"
        case data
    }

    enum DataKeys: String, CodingKey {
        case href
    }

    public init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(AutoCompleteType.self, forKey: .type)
        self.tekst = try values.decode(String.self, forKey: .tekst)
        self.forslagsTekst = try values.decode(String.self, forKey: .forslagsTekst)
        self.caretPosition = try values.decode(Int.self, forKey: .caretPosition)

        let dataInfo = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        self.href = try dataInfo.decode(String.self, forKey: .href)

    }
}
