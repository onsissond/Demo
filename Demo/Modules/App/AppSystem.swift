// 
// Copyright © 2021 onsissond. All rights reserved.
//

import ComposableArchitecture
import Core

struct AppState: Equatable {
    var title = "Hello, world!"
}

struct AppEvent: Equatable {
}

struct AppEnvironment {
    var appEnvironmentProvider: AppEnvironmentProvider
}

let appReducer = Reducer<AppState, AppEvent, AppEnvironment> { state, event, env in
    return .none
}

extension AppEnvironment {
    static var live = AppEnvironment(
        appEnvironmentProvider: .current
    )
}

#if DEBUG
extension AppState {
    static var mock = AppState()
}
extension AppEnvironment {
    static var mock = AppEnvironment(
        appEnvironmentProvider: .mock
    )
}
#endif
