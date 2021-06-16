// 
// Copyright © 2021 onsissond. All rights reserved.
//

import SwiftUI

// MARK: - AppEnvironmentProvider
public struct AppEnvironmentProvider {
    public let dateProvider: DateProvider
    public let localeProvider: LocaleProvider
    public let calendarProvider: CalendarProvider
    public let timeZoneProvider: TimeZoneProvider
    public let themeProvider: ThemeProvider
    public let dateFormatterProvider: DateFormatterProvider
}

extension AppEnvironmentProvider {
    public static var current = AppEnvironmentProvider(
        dateProvider: { Date() },
        localeProvider: { .current },
        calendarProvider: { .current },
        timeZoneProvider: { .current },
        themeProvider: {
            UIScreen.main.traitCollection.userInterfaceStyle
                .interfaceTheme
        },
        dateFormatterProvider: { config in
            let dateFormatter = DateFormatter()
            config.apply(dateFormatter: dateFormatter)
            return dateFormatter.string
        }
    )

    #if DEBUG
    public static var mock = AppEnvironmentProvider(
        dateProvider: { Date(timeIntervalSince1970: 0) },
        localeProvider: { .init(identifier: "ru-RU") },
        calendarProvider: { .init(identifier: .gregorian) },
        timeZoneProvider: { .init(identifier: "UTC")! },
        themeProvider: { .dark },
        dateFormatterProvider: { config in
            let dateFormatter = DateFormatter()
            config.apply(dateFormatter: dateFormatter)
            return dateFormatter.string
        }
    )
    #endif
}

// MARK: - Plane providers
public typealias DateProvider = () -> Date
public typealias LocaleProvider = () -> Locale
public typealias CalendarProvider = () -> Calendar
public typealias TimeZoneProvider = () -> TimeZone

// MARK: - ThemeProvider
public typealias ThemeProvider = () -> InterfaceTheme
public enum InterfaceTheme {
    case dark
    case light
}
private extension UIUserInterfaceStyle {
    var interfaceTheme: InterfaceTheme {
        switch self {
        case .unspecified,
             .light:
            return .light
        case .dark:
            return .dark
        @unknown default:
            return .light
        }
    }
}

// MARK: - DateFormatterProvider
public typealias DateFormatterProvider =
    (_ config: DateFormatterConfig) -> FormatDate
public typealias FormatDate = (Date) -> String
public enum DateFormatterConfig {
    case dateFormat(String)
}
extension DateFormatterConfig {
    fileprivate func apply(dateFormatter: DateFormatter) {
        switch self {
        case .dateFormat(let dateFormat):
            dateFormatter.dateFormat = dateFormat
        }
    }
}
