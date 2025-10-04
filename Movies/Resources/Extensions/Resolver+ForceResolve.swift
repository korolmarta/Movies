import Swinject

extension Resolver {
    func forceResolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = self.resolve(serviceType) else {
            fatalError("❌ Failed to resolve dependency: \(serviceType)")
        }
        return service
    }
}
