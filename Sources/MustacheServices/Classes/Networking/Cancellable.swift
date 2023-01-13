
import Foundation

public protocol Cancellable {
    
    func cancel()
    
}

extension NSURLConnection: Cancellable {
    
}


extension URLSessionTask: Cancellable {
    
}

extension OperationQueue: Cancellable {
    
    public func cancel() {
        self.cancelAllOperations()
    }
    
}
