//
//  Flag.swift
//  Flager
//
//  Created by Mina Ashna on 10/11/2021.
//

import SwiftUI

struct Flag: Decodable {
    let country: String
    let continent: String
    let zone: String
    let bars: Int
    let stripes: Int
    var colors: [String]
    let circles: Int
    let crosses: Int
    let saltires: Int
    let quarters: Int
    let sunstars: Int
    let crescent: Int
    let triangle: Int
    var text: Bool
    var symbol: Bool
    let imageName: String
}

struct Translation: Decodable {
   let id: Int
   let name: String
   let alpha2: String
   let alpha3: String
}

struct Country: Hashable {
    let countryName: String
    let countryKey: String
    let isoCode: String
}

class FlagViewModel: ObservableObject {
    @Published var country: Country
    @Published var countryKey: String
    @Published var continent: String
    @Published var zone: String
    @Published var bars: Int
    @Published var stripes: Int
    @Published var colors: Set<String>
    @Published var circles: Int
    @Published var crosses: Int
    @Published var saltires: Int
    @Published var quarters: Int
    @Published var sunstars: Int
    @Published var crescent: Int
    @Published var triangle: Int
    @Published var text: SelectionValue
    @Published var symbol: SelectionValue
    @Published var imageName: String

    init(flag: Flag) {
        self.countryKey = flag.country
        self.continent = flag.continent
        self.zone = flag.zone
        self.bars = flag.bars
        self.stripes = flag.stripes
        self.colors = Set(flag.colors)
        self.circles = flag.circles
        self.crosses = flag.crosses
        self.saltires = flag.saltires
        self.quarters = flag.quarters
        self.sunstars = flag.sunstars
        self.crescent = flag.crescent
        self.triangle = flag.triangle
        self.imageName = flag.imageName.lowercased()

        self.text = SelectionValue.maybe
        self.symbol = SelectionValue.maybe
        self.country = Country(countryName: "", countryKey: flag.country, isoCode: "")

        defer {
            self.country = getCountry(from: countryKey)
            self.text = parseValue(from: flag.text)
            self.symbol = parseValue(from: flag.symbol)
        }
    }

    private func getCountry(from key: String) -> Country {
        var countryName = key
        guard let countryCode = key.split(separator: ".").last?.lowercased() else {
            return Country(countryName: countryName, countryKey: key, isoCode: key)
        }

        countryName = FlagData().translationsEn.first(where: { $0.alpha2 ==  countryCode })?.name ?? key


        return Country(countryName: countryName, countryKey: key, isoCode: countryCode.uppercased())
    }

    private func parseValue(from value: Bool) -> SelectionValue {
        return value ? .yes : .no
    }
}

enum SelectionValue: CaseIterable, Identifiable {
    case yes
    case no
    case maybe
    var id: Self { self }

    var description: String {
        switch self {
        case .yes:
            return "Yes"
        case .no:
            return "No"
        case .maybe:
            return "Maybe"
        }
    }
}
