
import Foundation

public struct DAWAAddressSuggestion: Decodable {

    public let type: DAWAAddressSuggestionType
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
        self.type = try values.decode(DAWAAddressSuggestionType.self, forKey: .type)
        self.tekst = try values.decode(String.self, forKey: .tekst)
        self.forslagsTekst = try values.decode(String.self, forKey: .forslagsTekst)
        self.caretPosition = try values.decode(Int.self, forKey: .caretPosition)

        let dataInfo = try values.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        self.href = try dataInfo.decode(String.self, forKey: .href)

    }
    
    /*
     Forskellen på en adresse og en adgangsadresse er at adressen rummer eventuel etage- og/eller dørbetegnelse.
     Det gør adgangsadressen ikke.
     */
    
    public enum DAWAAddressSuggestionType: String, Codable {
        case vejnavn, adgangsadresse, adresse
    }
}
