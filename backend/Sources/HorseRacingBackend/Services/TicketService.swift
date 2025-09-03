import Foundation
import Vapor
import Plot
import VaporWalletPasses
import wkhtmltopdf
import WalletPasses

/// Service responsible for generating printable tickets (HTML/PDF)
/// and Apple Wallet passes.
///

struct TicketService {
	// MARK: - Embedded Assets
	
	/// Embedded 29x29 PNG icon for Apple Wallet passes
	/// This is the NoahBRAVE Foundation logo converted to the proper size
	static let embeddedIconData: Data = {
		let base64String = """
            iVBORw0KGgoAAAANSUhEUgAAAB0AAAAdCAYAAABWk2cPAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpg
            AAA6mAAAF3CculE8AAAARGVYSWZNTQAqAAAACAABh2kABAAAAAEAAAAaAAAAAAADoAEAAwAAAAEAAQAAoAIABAAAAAEAAAAdoAMABAAAAAEA
            AAAdAAAAAN57FlEAAAHKaVRYdFhNTDpjb20uYWRvYmUueG1wAAAAAAA8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIiB4Onht
            cHRrPSJYTVAgQ29yZSA2LjAuMCI+CiAgIDxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3lu
            dGF4LW5zIyI+CiAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiCiAgICAgICAgICAgIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5h
            ZG9iZS5jb20vZXhpZi8xLjAvIj4KICAgICAgICAgPGV4aWY6Q29sb3JTcGFjZT4xPC9leGlmOkNvbG9yU3BhY2U+CiAgICAgICAgIDxleGlm
            OlBpeGVsWERpbWVuc2lvbj4xMjA8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZjpQaXhlbFlEaW1lbnNpb24+OTE8L2V4
            aWY6UGl4ZWxZRGltZW5zaW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KdV6ABQAABTZJ
            REFUSA3tVmuIVFUc///POfexM2u26RezYsNH2ZZKHwJBtrWHZilqpKHsFqIYhYbZh4I+JBH0IQgztJDItjVxN0lSxCjFZYkVgyBDS2p8lKuu
            j7WZdWdn5t57zul/ZvbO3LnjVh/qmwcO5/F//P6v878X4Ob4HyOAoe6mLS31+bF1MxzNmEB15qfWA30hLb4ODg6OF0JMoXsVpVkArC+TuTh/
            3yrbu+ZdOv36wUyUHu5ZuPHHudMUuj2+Y/cMa96xtGspD2nx1bKseQTaK6U8Ep3KtnvdMfa6nPA+542Jo5N3PNEalzXnMqg5cJCAQQBM8Obj
            wbVHzN0/DCQDKpNz0EySsareQbiHC7t9cueTy+I6KqCBsUBrRgETDJkn3fWgoRz+uCA3AFqf8TxvMc2FkmYuPbwYZW6bDYntvm9nNOnBAN+c
            /tncZFReRA9mr1GDChQwzh+/d8dTs07C/t44jzkzxoCA08lk8qsb0H9+4NNnzvtcd2jEadq1pxPPkZCv4indIGqmQfcprY5xh1kIfF3IOMqK
            5G2N4YY3J7L7tC/PcyHIeTYpKl8FSgQKp84i6M0kQLHGRVM7FsyICvzbvWPX50lPWqEEnykq7Moog1pgmRwBme5eZ2yvCuB7nbTqCpyvrbCX
            dlSxxQ3iqCkHK+snANVtEEgQoKqeXxm0pI7ySUFumOEOSgbvi3wACRUsa+qaNzkOPHKmlCGVYO0o2LAQHXY7BKrf9/WPUY6qfJhiVWT9xd9t
            95YJV/aoPuc4Sybv11n+Igm9GhU0UaGRyGazDwqR8DYefedS5x89jUxhglQ0o8YNElHRA3o31XbgSlS2ylMTLCokUIUsOzunOy9tthmVMhX9
            3NSuBROjggG9Z6XUVArMUQaqO7DtFUTvRca60RJvKVveqj3ZlVrx9XtRObOvAjUXZKFZikP50ClzwW/o8PEsJ1aH9+aNjgxyCulAUwPTSguT
            Z6PB9EffwnmTdi58g4qlopTua0CLBTyiMdV6YBCU2MKUpm6lVk88uGTcCAmoDZq3+qsJJSV2LkrZKZT/MOjgMeHpNeDrHldjg7LU2007lz4b
            ypm1KqdRQrinPO/QuWCDrhd3WVeDNrrfZGw1HlFehxKJxHchL60XRvaHGre3dNg68aXl8vmeLLzccrhld/ec7mLR1XpKHSk6Tj6/Z8C3xUeS
            IzhSvQQbwXUtu/RmTDZGaQ5nV3bnqRo22XmqEQH3ncuMnRDqrQEtNt+QOrJ6hfT2IOv1g2NPabhj9tMwJKs+aTH28rEegzMeqgJynXQ9LKem
            BhRVVc6LCsjqfornx5xCOkbYay+Ia6UGXqqZMkh841vUiaivFauqEJRDWAMKrBa0qIx52/RwMIAcH9p1av8iTR8FrstVHMcrnj3PmYmWbXHJ
            0shZf8hUCxpSYuup5d+c08xpB8H5xT8vLzBOmsdv+kmMtXic2P7oOIbWKxRaynzhh+PL914O+Wqr9wbhDZm5gg+1lKvoSY6lVwQD/kDDrJ3r
            lkyS86VdfAgBGWI6I7uTvFmpGM5UPjURpraSceXwVkCFDyApBX+TpxNtX6QmfDJ7F/0qvCBJx9V85u4Ag92cviFaG4dZ6eFTiugLRd1CUnfD
            ranWb/fB8tD0quZgUa0QYZSUhiLXg/4P6nz/ugEx/VdTIVdN0zZ96pGeSilv+LX64Qvro14aPRVPmfsL94ebPYaF9LH0UAgSX4fWpE6MOSya
            6etWR14SsO8o+rUqlWiJWzp+RjF26vSyQzf8G4zrvHn+TyPwFx26M6wuDaUFAAAAAElFTkSuQmCC
            """.replacingOccurrences(of: "\n", with: "")
		guard let data = Data(base64Encoded: base64String) else {
			fatalError("Failed to decode embedded icon data")
		}
		return data
	}()

	// MARK: - Public API

	/// Render an HTML page containing all tickets in the provided cart.
	/// Uses Plot Swift DSLs to build the document.
	/// - Returns: Complete HTML string ready for printing or PDF conversion.
	static func renderTicketsHTML(for cart: Cart, user: User, on req: Request) async throws -> String {
		let tickets = try await cart.$tickets.get(on: req.db)

		let eventTitle = "A Night at the Races"
		let eventUrl = "https://horses.noahbrave.org"
		let eventMeta = "Sat Nov 22, 2025 • 6:00 PM • Tina's Country House & Garden"
		let ticketPriceFormatted = Pricing.getFormattedPrice(for: .ticket)

		// Lightweight inline styles adapted from the provided template
		let styles = """
		:root { --brand: #0891b2; --brand-ink: #075985; --ink: #111827; --muted: #6b7280; --border: #d1d5db; --bg: #ffffff; }
		* { box-sizing: border-box; }
		html, body { margin: 0; padding: 0; }
		body { font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica,Arial,sans-serif; color: var(--ink); background: var(--bg); }
		.container { max-width: 900px; margin: 24px auto; padding: 0 16px; }
		.header { display: flex; align-items: baseline; justify-content: space-between; margin: 8px 0 16px; border-bottom: 3px solid var(--brand); padding-bottom: 8px; }
		.grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 14px; }
		.ticket { border: 2px solid var(--brand); border-radius: 14px; overflow: hidden; page-break-inside: avoid; background: #fff; box-shadow: 0 2px 6px rgba(0,0,0,.06); }
		.ticket__header { display: grid; grid-template-columns: 72px 1fr auto; align-items: center; gap: 12px; background: color-mix(in oklab, var(--brand) 10%, white); padding: 12px; border-bottom: 2px dashed var(--brand); }
		.ticket__logo { width: 72px; height: 72px; object-fit: contain; }
		.ticket__event h2 { margin: 0; font-size: 16px; line-height: 1.2; }
		.ticket__url { margin: 2px 0 0; color: var(--brand-ink); font-weight: 600; font-size: 12px; }
		.ticket__meta { margin: 2px 0 0; color: var(--muted); font-size: 12px; }
		.ticket__price { font-size: 18px; font-weight: 800; color: var(--brand-ink); background: #fff; border: 2px solid var(--brand); padding: 6px 10px; border-radius: 10px; }
		.ticket__body { padding: 12px; display: grid; gap: 4px; }
		.label { color: var(--muted); font-weight: 600; margin-right: 6px; }
		.ticket__barcode { margin: 0 12px 12px; border: 2px dashed var(--border); background: repeating-linear-gradient(90deg, #000 0 3px, #fff 3px 6px); height: 52px; position: relative; border-radius: 8px; overflow: hidden; }
		.ticket__barcode span { position: absolute; inset: auto 8px 6px auto; background: #fff; color: #000; padding: 2px 6px; border-radius: 6px; font-size: 10px; border: 1px solid var(--border); }
		.ticket__fineprint { font-size: 11px; color: var(--muted); border-top: 1px solid var(--border); padding: 10px 12px; }
		"""

		let logoURL = "https://horses.noahbrave.org/ticket-horse.png"

		let ticketNodes: [Node<HTML.BodyContext>] = tickets.map { ticket in
			.article(
				.class("ticket"),
				.attribute(named: "aria-label", value: "Ticket for \(ticket.attendeeFirst) \(ticket.attendeeLast)"),
				.div(
					.class("ticket__header"),
					.img(.class("ticket__logo"), .src(logoURL), .alt("Logo")),
					.div(
						.class("ticket__event"),
						.h2(.text(eventTitle)),
						.p(.class("ticket__url"), .text(URL(string: eventUrl)?.host ?? eventUrl)),
						.p(.class("ticket__meta"), .text(eventMeta))
					),
					.div(.class("ticket__price"), .text(ticketPriceFormatted))
				),
				.div(
					.class("ticket__body"),
					.p(
						.class("ticket__name"),
						.span(.class("label"), "Admit:"),
						" \(ticket.attendeeFirst) \(ticket.attendeeLast)"
					),
					.p(
						.class("ticket__code"),
						.span(.class("label"), "Ticket ID:"),
						" \(ticket.id?.uuidString.prefix(12) ?? "TBD")"
					)
				),
				.div(
					.class("ticket__barcode"),
					.attribute(named: "aria-label", value: "Barcode placeholder"),
					.attribute(named: "data-barcode", value: "TBD"),
					.span("Barcode will be generated")
				),
				.footer(
					.class("ticket__fineprint"),
					"Please present this ticket at the entrance. Non-transferable. No refunds."
				)
			)
		}

		let document = HTML(
			.head(
				.title("\(eventTitle) — Tickets"),
				.raw("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"),
				.raw("<style>\n\(styles)\n</style>")
			),
			.body(
				.div(
					.class("container"),
					.div(
						.class("header"),
						.h1("\(eventTitle) — Tickets"),
						.a(.href(eventUrl), "horses.noahbrave.org")
					),
					.section(
						.class("grid"),
						.group(ticketNodes)
					)
				)
			)
		)

		let html = document.render()
		return html
	}

	/// Convert an HTML string to PDF data using the WKHTMLToPDF SPM package.
	static func convertHTMLToPDF(_ html: String, on req: Request) throws -> EventLoopFuture<Data> {
		// Use environment variable for wkhtmltopdf path, defaulting to our wrapper script
		let wkhtmltopdfPath = Environment.get("WKHTMLTOPDF_PATH") ?? "/usr/local/bin/wkhtmltopdf"
		let document = wkhtmltopdf.Document(margins: 10, path: wkhtmltopdfPath)
		document.pages = [wkhtmltopdf.Page(html)]
		return try document.generatePDF(on: req.application.threadPool, eventLoop: req.eventLoop)
	}

	/// Convenience: Render tickets from a cart to HTML and return PDF data.
	static func renderTicketsPDF(for cart: Cart, user: User, on req: Request) async throws -> Data {
		let html = try await renderTicketsHTML(for: cart, user: user, on: req)
		return try await convertHTMLToPDF(html, on: req).get()
	}

	
	/// Generate Apple Wallet passes for all tickets in a cart.
	/// Returns a dictionary mapping ticket IDs to pass data.
	static func generateAppleWalletPasses(for cart: Cart, user: User, on req: Request) async throws -> [UUID: Data] {
		let tickets = try await cart.$tickets.get(on: req.db)
		var passes: [UUID: Data] = [:]
		
		for ticket in tickets {
			guard let ticketId = ticket.id else { continue }
			let passData = try await generateCustomAppleWalletPass(for: ticket, user: user, cart: cart, on: req)
			passes[ticketId] = passData
		}
		
		return passes
	}

	/// Generate a single Apple Wallet pass with custom styling and fields.
	static func generateCustomAppleWalletPass(
		for ticket: Ticket,
		user: User,
		cart: Cart,
		style: PassStyle = .default,
		on req: Request
	) async throws -> Data {
		req.logger.info("🎫 [TicketService] Starting Apple Wallet pass generation")
		
		// Create custom event ticket pass
		let eventPass = EventTicketPass(
			description: style.description,
			formatVersion: .v1,
			organizationName: "NoahBRAVE Foundation",
			passTypeIdentifier: "pass.org.noahbrave.races",
			serialNumber: ticket.id?.uuidString ?? UUID().uuidString,
			teamIdentifier: "VSK4YJB7D8",
			logoText: style.logoText ?? "NoahBRAVE Foundation",
			backgroundColor: style.backgroundColor,
			foregroundColor: style.foregroundColor,
			labelColor: style.labelColor,
			barcodes: [
				EventTicketBarcode(
					format: style.barcodeFormat,
					message: "\(ticket.id?.uuidString ?? "TICKET")",
					messageEncoding: "iso-8859-1"
				)
			],
			eventTicket: EventTicket(
				primaryFields: style.primaryFields(ticket, cart),
				secondaryFields: style.secondaryFields(ticket, cart),
				auxiliaryFields: style.auxiliaryFields(ticket, cart)
			)
		)

		// Create temporary directory for pass files
		let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent("pass-\(UUID().uuidString)")
		try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

		defer {
			try? FileManager.default.removeItem(at: tempDir)
		}

		// Add pass assets - Apple Wallet passes require an icon file
		// The icon should be 29x29 pixels for optimal display
		let iconPath = tempDir.appendingPathComponent("icon.png")
		try TicketService.embeddedIconData.write(to: iconPath)
		
		req.logger.info("🎫 [TicketService] Created pass structure and assets, calling PassBuilder.build()")

		// Use PassBuilder singleton to build the pass
		do {
			let passData = try req.application.passBuilderService.build(
				pass: eventPass,
				sourceFilesDirectoryPath: tempDir.path
			)
			req.logger.info("✅ [TicketService] Pass built successfully: \(passData.count) bytes")
			return passData
		} catch {
			req.logger.error("❌ [TicketService] Pass build failed: \(error)")
			throw error
		}
	}
}

// MARK: - Apple Wallet Pass Structures

/// Event ticket pass structure conforming to PassJSON.Properties
struct EventTicketPass: PassJSON.Properties, Encodable {
	let description: String
	let formatVersion: PassJSON.FormatVersion
	let organizationName: String
	let passTypeIdentifier: String
	let serialNumber: String
	let teamIdentifier: String
	let logoText: String
	let backgroundColor: String
	let foregroundColor: String
	let labelColor: String
	let barcodes: [EventTicketBarcode]
	let eventTicket: EventTicket
}

/// Event ticket barcode structure
struct EventTicketBarcode: PassJSON.Barcodes, Encodable {
	let format: PassJSON.BarcodeFormat
	let message: String
	let messageEncoding: String
}

/// Event ticket structure
struct EventTicket: Encodable {
	let primaryFields: [EventTicketField]
	let secondaryFields: [EventTicketField]
	let auxiliaryFields: [EventTicketField]
}

/// Event ticket field structure
struct EventTicketField: PassJSON.PassFieldContent, Encodable {
	let key: String
	let label: String
	let value: String
}

/// Pass styling configuration
struct PassStyle: Sendable {
	let description: String
	let logoText: String?
	let backgroundColor: String
	let foregroundColor: String
	let labelColor: String
	let barcodeFormat: PassJSON.BarcodeFormat
	let iconData: Data?
	
	/// Function to generate primary fields for the pass
	let primaryFields: @Sendable (Ticket, Cart) -> [EventTicketField]
	/// Function to generate secondary fields for the pass
	let secondaryFields: @Sendable (Ticket, Cart) -> [EventTicketField]
	/// Function to generate auxiliary fields for the pass
	let auxiliaryFields: @Sendable (Ticket, Cart) -> [EventTicketField]
	
	/// Default pass style
	static let `default` = PassStyle(
		description: "Event Ticket",
		logoText: nil,
		backgroundColor: "rgb(35, 159, 9)",
		foregroundColor: "rgb(255, 255, 255)",
		labelColor: "rgb(34, 34, 34)",
		barcodeFormat: .pdf417,
		iconData: TicketService.embeddedIconData,
		primaryFields: { ticket, cart in
			[
				EventTicketField(key: "attendee", label: "Admit", value: "\(ticket.attendeeFirst) \(ticket.attendeeLast)")
			]
		},
		secondaryFields: { ticket, cart in
			[
				EventTicketField(key: "order", label: "Order", value: cart.orderNumber),
				EventTicketField(key: "event", label: "Event", value: "A Night at the Races")
			]
		},
		auxiliaryFields: { ticket, cart in
			[
				EventTicketField(key: "date", label: "Date", value: "November 22, 2025"),
				EventTicketField(key: "time", label: "Time", value: "6:00 PM"),
                EventTicketField(key: "location", label: "Location", value: "Tina's Country House & Garden")
			]
		}
	)
}


