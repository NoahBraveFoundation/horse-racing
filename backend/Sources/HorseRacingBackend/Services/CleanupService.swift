import Vapor
import Fluent

enum CleanupService {
    // MARK: - Configuration
    struct Config {
        static let horseTimeout: TimeInterval = TimeInterval(Environment.get("HORSE_TIMEOUT_MINUTES") ?? "15")! * 60
        static let cartTimeout: TimeInterval = TimeInterval(Environment.get("CART_TIMEOUT_HOURS") ?? "1")! * 60 * 60
        static let paymentTimeout: TimeInterval = TimeInterval(Environment.get("PAYMENT_TIMEOUT_HOURS") ?? "24")! * 60 * 60
    }
    
    // MARK: - Horse Lane Cleanup
    // static func cleanupExpiredHorses(on req: Request) -> EventLoopFuture<Void> {
    //     let cutoffDate = Date().addingTimeInterval(-Config.horseTimeout)
        
    //     return Horse.query(on: req.db)
    //         .filter(\.$state == .onHold)
    //         .filter(\.$createdAt < cutoffDate)
    //         .all()
    //         .flatMap { expiredHorses in
    //             guard !expiredHorses.isEmpty else {
    //                 return req.eventLoop.makeSucceededFuture(())
    //             }
                
    //             req.logger.info("Cleaning up \(expiredHorses.count) expired horses")
                
    //             return EventLoopFuture.whenAllSucceed(
    //                 expiredHorses.map { horse in
    //                     horse.delete(on: req.db)
    //                 }, on: req.eventLoop
    //             ).map { _ in }
    //         }
    // }
    
    // MARK: - Cart Cleanup
    static func cleanupAbandonedCarts(on req: Request) -> EventLoopFuture<Void> {
        let cutoffDate = Date().addingTimeInterval(-Config.cartTimeout)
        
        return Cart.query(on: req.db)
            .filter(\.$status == .open)
            .filter(\.$updatedAt < cutoffDate)
            .all()
            .flatMap { abandonedCarts in
                guard !abandonedCarts.isEmpty else {
                    return req.eventLoop.makeSucceededFuture(())
                }
                
                req.logger.info("Cleaning up \(abandonedCarts.count) abandoned carts")
                
                return EventLoopFuture.whenAllSucceed(
                    abandonedCarts.map { cart in
                        cart.status = .abandoned
                        return cart.save(on: req.db)
                    }, on: req.eventLoop
                ).map { _ in }
            }
    }
    
    // MARK: - Login Token Cleanup
    static func cleanupExpiredTokens(on req: Request) -> EventLoopFuture<Void> {
        return LoginToken.query(on: req.db)
            .filter(\.$expiresAt < Date())
            .delete()
            .flatMap { _ in
                req.logger.info("Cleaned up expired login tokens")
                return req.eventLoop.makeSucceededFuture(())
            }
    }
    
    // MARK: - Comprehensive Cleanup
    static func runAllCleanups(on req: Request) -> EventLoopFuture<Void> {
        req.logger.info("Starting scheduled cleanup tasks")
        
        return cleanupExpiredTokens(on: req)
            .flatMap { _ in
                cleanupAbandonedCarts(on: req)
            }
            .flatMap { _ in
                req.logger.info("Completed scheduled cleanup tasks")
                return req.eventLoop.makeSucceededFuture(())
            }
    }
}
