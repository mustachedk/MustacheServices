//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

public struct AutoCompleteContainer: Codable {

    /// Den tekst, som input-feltet skal udfyldes med, hvis brugeren vælger forslaget
    public var tekst: String

    /// Forslagets type: "vejnavn", "adgangsadresse" eller "adresse"
    public var type: AddressType

    /// Den tekst, der skal vises for dette forslag. Kan afvige fra den tekst der skal udfyldes i input-feltet.
    public var forslagstekst: String

    ///Den position hvor careten (cursoren) skal placeres i inputfeltet, hvis brugeren vælger forslaget
    public var caretpos: Int

    ///Udvalgte datafelter for vejnavnet, adgangsadressen eller adressen der returneres.
    public var data: Codable

    enum CodingKeys: String, CodingKey {
        case type
        case tekst
        case forslagstekst
        case caretpos
        case data
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.tekst = try values.decode(String.self, forKey: .tekst)
        self.type = try values.decode(AddressType.self, forKey: .type)
        self.forslagstekst = try values.decode(String.self, forKey: .forslagstekst)
        self.caretpos = try values.decode(Int.self, forKey: .caretpos)

        switch self.type {
            case .vejnavn:
                self.data = try values.decode(AutoCompleteVejNavn.self, forKey: .data)
            case .adgangsadresse:
                self.data = try values.decode(AutoCompleteAdgangsAdresse.self, forKey: .data)
            case .adresse:
                self.data = try values.decode(AutoCompleteAdresse.self, forKey: .data)
            case .postnumre:
                self.data = try values.decode(AutoCompletePostnummer.self, forKey: .data)
        }
    }

    public init(adresse: AutoCompleteAdresseContainer){
        self.tekst = adresse.tekst
        self.type = .adresse
        self.forslagstekst = adresse.tekst
        self.caretpos = adresse.tekst.count
        self.data = adresse.adresse
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.tekst, forKey: .tekst)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.forslagstekst, forKey: .forslagstekst)
        try container.encode(self.caretpos, forKey: .caretpos)
        switch self.type {
            case .vejnavn:
                try container.encode(self.data as? AutoCompleteVejNavn, forKey: .data)
            case .adgangsadresse:
                try container.encode(self.data as? AutoCompleteAdgangsAdresse, forKey: .data)
            case .adresse:
                try container.encode(self.data as? AutoCompleteAdresse, forKey: .data)
            case .postnumre:
                try container.encode(self.data as? AutoCompletePostnummer, forKey: .data)
        }
    }
}
