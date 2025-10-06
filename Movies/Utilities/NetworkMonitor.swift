import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = true
    
    var onStatusChange: ((Bool) -> Void)?
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            self?.isConnected = connected
            DispatchQueue.main.async {
                self?.onStatusChange?(connected)
            }
        }
        monitor.start(queue: queue)
    }
}
