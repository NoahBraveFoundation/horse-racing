import Fluent

struct AlterPaymentsAddCartReference: Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
                database.schema("payments")
                        .deleteUnique(on: "user_id")
                        .field("cart_id", .uuid, .references("carts", "id", onDelete: .setNull))
                        .update()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
                database.schema("payments")
                        .deleteField("cart_id")
                        .unique(on: "user_id")
                        .update()
        }
}
