//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

/**
    Forskellen på en adresse og en adgangsadresse er at adressen rummer eventuel etage- og/eller dørbetegnelse.
    Det gør adgangsadressen ikke.
*/
public enum AddressType: String, Codable {
    case vejnavn, adgangsadresse, adresse, postnumre
}
