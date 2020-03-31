//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

public struct AutoCompleteAdgangsAdresse: Codable {
    var id: String
    var vejnavn: String
    var husnr: String
    var supplerendebynavn: String?
    var postnr: String
    var postnrnavn: String
    var x: Double
    var y: Double
    var href: String
}

