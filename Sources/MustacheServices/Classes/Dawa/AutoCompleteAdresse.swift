//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

public struct AutoCompleteAdresse: Codable {
    public var id: String
    public var vejnavn: String
    public var husnr: String
    public var etage: String?
    public var dør: String?
    public var supplerendebynavn: String?
    public var postnr: String
    public var postnrnavn: String
    public var x: Double
    public var y: Double
    public var href: String
}

public struct AutoCompleteAdresseContainer: Codable {
    public var tekst: String
    public var adresse: AutoCompleteAdresse
}
