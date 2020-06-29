import Foundation

public struct AdgangsAdresse: Codable {
    public let href: String
    public let id: String
    public let vejstykke: Vejstykke
    public let husnr: String
    public let supplerendebynavn: String?
    public let postnummer: Postnummer
    public let adgangspunkt: Adgangspunkt

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case id = "id"
        case vejstykke = "vejstykke"
        case husnr = "husnr"
        case supplerendebynavn = "supplerendebynavn"
        case postnummer = "postnummer"
        case adgangspunkt = "adgangspunkt"
    }
}

public struct Vejstykke: Codable {
    public let href: String
    public let navn: String

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case navn = "navn"
    }
}

public struct Adgangspunkt: Codable {
    public let id: String
    public let koordinater: [Double]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case koordinater = "koordinater"
    }
}

public struct Postnummer: Codable {
    public let href: String
    public let nr: String
    public let navn: String

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case nr = "nr"
        case navn = "navn"
    }
}
