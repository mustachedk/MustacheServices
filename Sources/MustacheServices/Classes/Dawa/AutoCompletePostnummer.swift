//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

public struct AutoCompletePostnummer: Codable {
    var nr: String
    var navn: String
    var href: String
}

public struct AutoCompletePostnummerContainer: Codable {
    var tekst: String
    var postnummer: AutoCompletePostnummer
}