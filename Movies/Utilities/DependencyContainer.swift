import Swinject

final class DependencyContainer {
    static let shared = DependencyContainer()
    let container = Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {
        container.register(MoviesFetchingServiceProtocol.self) { _ in
            MoviesFetchingService()
        }
        .inObjectScope(.container)
    }
}


