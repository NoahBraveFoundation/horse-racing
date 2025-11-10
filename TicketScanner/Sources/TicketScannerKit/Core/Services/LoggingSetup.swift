import Logging

// Global logging bootstrap executed at module load.
// Ensures all Logger(label:) instances default to .debug level output.
private let _loggingBootstrap: Void = {
  LoggingSystem.bootstrap { label in
    var handler = StreamLogHandler.standardError(label: label)
    handler.logLevel = .debug
    return handler
  }
}()

// Expose a no-op function to force referencing from app if needed.
public func ensureLoggingBootstrapped() {
  _ = _loggingBootstrap
}
