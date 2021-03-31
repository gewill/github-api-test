import Foundation
import RealmSwift

let realmQueue = DispatchQueue(label: "org.gewill.github-api-test.realm",
                               qos: .background,
                               attributes: [.concurrent])

struct RealmProvider {
    let configuration: Realm.Configuration

    internal init(config: Realm.Configuration) {
        configuration = config
    }

    var realm: Realm {
        return try! Realm(configuration: configuration)
    }

    // MARK: - github

    private static let githubConfig = Realm.Configuration(
        fileURL: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("github.realm"),
        schemaVersion: 1,
        deleteRealmIfMigrationNeeded: true)

    static var github: RealmProvider = {
        RealmProvider(config: githubConfig)
    }()
}
