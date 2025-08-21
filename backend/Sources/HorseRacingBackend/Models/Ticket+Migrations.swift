import Fluent

struct MigrateTicketsAddCart: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.field("cart_id", .uuid, .references("carts", "id", onDelete: .setNull))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.deleteField("cart_id")
			.update()
	}
}

struct MigrateTicketsAddState: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.field("state", .string, .required, .sql(.default("on_hold")))
			.update()
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema("tickets")
			.deleteField("state")
			.update()
	}
}

struct MigrateTicketsAddCanRemove: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .field("can_remove", .bool, .required, .sql(.default(false)))
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tickets")
            .deleteField("can_remove")
            .update()
    }
}


