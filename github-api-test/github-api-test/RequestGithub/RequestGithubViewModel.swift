import Alamofire
import Foundation
import PKHUD
import RealmSwift
import Repeat

/// request github view model
final class RequestGithubViewModel {
    // MARK: - properties

    private var token: NotificationToken?
    private var realm: Realm { RealmProvider.github.realm }

    var githubs: Results<GithubModel> {
        return realm.objects(GithubModel.self)
            .sorted(byKeyPath: GithubModel.Property.createAt.rawValue, ascending: false)
    }

    var timer: Repeater?

    /// data did update callback
    var didUpdate: (() -> Void)? {
        didSet {
            guard let didUpdate = didUpdate else {
                token?.invalidate()
                return
            }

            token = githubs.observe({ changes in
                switch changes {
                case .initial:
                    didUpdate()
                case .update:
                    didUpdate()
                case let .error(e):
                    HUD.flash(.labeledError(title: "Data error", subtitle: e.localizedDescription), delay: 2)
                }
            })
        }
    }

    // MARK: - life cycle

    init() {
        startRepeatlyRequestData()
    }

    deinit {
        token?.invalidate()
    }

    // MARK: - network methods

    private func startRepeatlyRequestData() {
        timer = Repeater.every(.seconds(5), { [weak self] _ in
            self?.requestData()
        })
    }

    private func requestData() {
        AF.request("https://api.github.com",
                   method: .get)
            .responseString { [weak self] response in
                guard let `self` = self else { return }
                switch response.result {
                case let .success(content):
                    HUD.flash(.labeledSuccess(title: "Request success", subtitle: nil), delay: 2)
                    realmQueue.async {
                        try? self.realm.write {
                            let github = GithubModel()
                            github.content = content
                            self.realm.add(github, update: .all)
                        }
                    }
                case let .failure(error):
                    HUD.flash(.labeledError(title: "Request error", subtitle: error.localizedDescription), delay: 2)
                }
            }
    }
}
