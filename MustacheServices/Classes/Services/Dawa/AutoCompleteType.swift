
import Foundation

/*
Forskellen på en adresse og en adgangsadresse er at adressen rummer eventuel etage- og/eller dørbetegnelse.
Det gør adgangsadressen ikke.
*/
public enum AutoCompleteType: String, Codable {
    case vejnavn, adgangsadresse, adresse
}
