//
// Created by Tommy Sadiq Hinrichsen on 06/02/2020.
// Copyright (c) 2020 Adoor ApS. All rights reserved.
//

import Foundation

public struct AutoCompletePostnummer: Codable {
   public var nr: String
   public var navn: String
   public var href: String
}

public struct AutoCompletePostnummerContainer: Codable {
    public var tekst: String
    public var postnummer: AutoCompletePostnummer
}
