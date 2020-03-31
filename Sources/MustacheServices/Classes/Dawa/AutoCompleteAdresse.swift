//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

public struct AutoCompleteAdresse: Codable {
    var id: String
    var vejnavn: String
    var husnr: String
    var etage: String?
    var dør: String?
    var supplerendebynavn: String?
    var postnr: String
    var postnrnavn: String
    var x: Double
    var y: Double
    var href: String
}

public struct AutoCompleteAdresseContainer: Codable {
    var tekst: String
    var adresse: AutoCompleteAdresse
}
