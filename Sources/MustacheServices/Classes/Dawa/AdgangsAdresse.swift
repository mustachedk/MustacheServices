// AdgangsAdresse.swift

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let adgangsAdresse = try? newJSONDecoder().decode(AdgangsAdresse.self, from: jsonData)

import Foundation

// MARK: - AdgangsAdresse
public struct AdgangsAdresse: Codable {
    let href: String
    let id: String
    let vejstykke: Vejstykke
    let husnr: String
    let navngivenvej: Vejstykke
    let supplerendebynavn: String?
    let postnummer: Postnummer
    let adgangspunkt: Adgangspunkt

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case id = "id"
        case vejstykke = "vejstykke"
        case husnr = "husnr"
        case navngivenvej = "navngivenvej"
        case supplerendebynavn = "supplerendebynavn"
        case postnummer = "postnummer"
        case adgangspunkt = "adgangspunkt"
    }
}

public struct Vejstykke: Codable {
    let href: String
    let kode: String
    let navn: String
    let adresseringsnavn: String?

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case kode = "kode"
        case navn = "navn"
        case adresseringsnavn = "adresseringsnavn"
    }
}

public struct Adgangspunkt: Codable {
    let id: String
    let koordinater: [Double]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case koordinater = "koordinater"
    }
}

public struct Postnummer: Codable {
    let href: String
    let nr: String
    let navn: String

    enum CodingKeys: String, CodingKey {
        case href = "href"
        case nr = "nr"
        case navn = "navn"
    }
}
