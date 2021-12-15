//
//  CountModel.swift
//  AshtrayCoreData
//
//  Created by Leopold Lemmermann on 12.12.21.
//

import CoreData



class Count: NSManagedObject/*, Codable*/ {
	/*enum CodingKeys: CodingKey {
		case id, amount
	}
	
	required convenience init(from decoder: Decoder) throws {
		guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else {
			fatalError("Decoding failed.")
		}
		
		self.init(context: context)
		
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Date.self, forKey: .id)
		self.amount = try container.decode(Int16.self, forKey: .amount)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(amount, forKey: .amount)
	}
	
	static func addCountsToContext(_ objects: Array<Count>, context: NSManagedObjectContext) throws {
		try addArrayToContext(objects, context: context)
	}*/
}

extension Count {
    public var wrappedId: Date { self.id ?? Date() }
    public var wrappedAmount: Int { Int(self.amount) }
}
/*
extension CodingUserInfoKey {
	static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
	convenience init(context: NSManagedObjectContext) {
		self.init()
		self.userInfo[.context] = context
	}
	
	convenience init(context: NSManagedObjectContext , dateFormat: String) {
		self.init(context: context)
		self.dateDecodingStrategy = .formatted(DateFormatter(dateFormat: dateFormat))
	}
}

extension JSONEncoder {
	convenience init(dateFormat: String) {
		self.init()
		self.dateEncodingStrategy = .formatted(DateFormatter(dateFormat: dateFormat))
	}
}

extension DateFormatter {
	convenience init(dateFormat: String) {
		self.init()
		self.dateFormat = dateFormat
	}
}

func addArrayToContext<T: NSManagedObject>(_ objects: Array<T>, context: NSManagedObjectContext) throws {
	objects.forEach { object in
		let item = T(context: context)
		item.entity.attributesByName.keys.forEach { attribute in
			item.setValue(object.value(forKey: attribute), forKey: attribute)
		}
	}
	try context.save()
}*/
