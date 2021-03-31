import Foundation
import RealmSwift

/// github api response model
@objcMembers class GithubModel: Object {
    enum Property: String {
        case uuid, content, createAt
    }

    dynamic var uuid: String = UUID().uuidString
    dynamic var content: String = ""
    dynamic var createAt: Date = Date()

    override class func primaryKey() -> String? {
        return Property.uuid.rawValue
    }
}
