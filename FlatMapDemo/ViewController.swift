import RxCocoa
import RxSwift
import UIKit
import RxDataSources

class ViewController: UIViewController {

    var demoView: DemoView! { return view as? DemoView }

    override func loadView() {
        view = DemoView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        demoView.button.rx.tap
            .scan(0) { acc, _ in acc + 1 }
            .do(onNext: { [weak self] in self?.demoView.counter.text = "Tap count:\n\($0)" })
            .flatMapLatest { [unowned self] count -> Observable<Data> in
                let url = "https://jsonplaceholder.typicode.com/todos/\(count)"
                let request = URLRequest(url: URL(string: url)!)
                let delay = Double.random(in: 2.5..<5)

                return URLSession.shared.rx.data(request: request)
                    .delay(delay, scheduler: MainScheduler.instance)
                    .do(
                        onCompleted: {
                            self.completeRequest(withID: count)
                        },
                        onSubscribed: {
                            self.newRequest(to: url, withID: count)
                        }, onDispose: {
                            self.cancelRequest(withID: count)
                        }
                    )
            }
            .subscribe()
            .disposed(by: disposeBag)

        let animation = AnimationConfiguration(insertAnimation: .right, reloadAnimation: .fade, deleteAnimation: .left)

        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Request>>(
            animationConfiguration: animation,
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell

                cell.urlLabel.text = item.url
                cell.statusLabel.text = item.status.rawValue
                cell.statusLabel.textColor = item.status.color

                if let finished = item.finished {
                    let formatted = String(format: "%.5f", finished.timeIntervalSince(item.started))
                    cell.timeLabel.text = "\(formatted) s"
                } else {
                    cell.timeLabel.text = "-"
                }

                return cell
        })

        requests
            .map { [AnimatableSectionModel(model: "", items: $0)] }
            .bind(to: demoView.requestsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func newRequest(to url: String, withID id: Int) {
        let request = Request(id: id, url: url, status: .pending, started: Date(), finished: nil)
        self.requests.accept(self.requests.value + [request])
    }

    private func completeRequest(withID id: Int) {
        let requests = self.requests.value.map { request -> Request in
            guard request.id == id else { return request }

            var copy = request
            copy.status = .finished
            copy.finished = Date()

            return copy
        }

        self.requests.accept(requests)
    }

    private func cancelRequest(withID id: Int) {
        let requests = self.requests.value.map { request -> Request in
            guard request.id == id, request.status != .finished else { return request }

            var copy = request
            copy.status = .cancelled

            return copy
        }

        self.requests.accept(requests)

        Observable.just(())
            .delay(1.5, scheduler: MainScheduler.instance)
            .withLatestFrom(self.requests)
            .map { requests in
                requests.filter { !($0.id == id && $0.status == .cancelled) }
            }
            .bind(to: self.requests)
            .disposed(by: disposeBag)
    }

    private let disposeBag = DisposeBag()
    private let requests = BehaviorRelay<[Request]>(value: [])

}
