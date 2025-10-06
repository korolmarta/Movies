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
        
        container.register(MoviesListViewModel.self) { resolver in
            let service = resolver.forceResolve(MoviesFetchingServiceProtocol.self)
            return MoviesListViewModel(moviesService: service)
        }
        
        container.register(MoviesListViewController.self) { resolver in
            let viewModel = resolver.forceResolve(MoviesListViewModel.self)
            return MoviesListViewController(viewModel: viewModel)
        }
    }
}


