import SnapKit
import UIKit

class DemoView: UIView {

    let leftContainer = UIView(frame: .zero)
    let rightContainer = UIView(frame: .zero)

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 30.0, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitle("flatMap\nLatest", for: .normal)

        return button
    }()

    let requestsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(RequestCell.self, forCellReuseIdentifier: "RequestCell")
        tableView.rowHeight = UITableView.automaticDimension

        return tableView
    }()

    let counter: UILabel = {
        let counter = UILabel(frame: .zero)
        counter.font = .systemFont(ofSize: 30.0, weight: .medium)
        counter.text = "Tap count:\n0"
        counter.textAlignment = .center
        counter.numberOfLines = 2

        return counter
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        addSubview(leftContainer)
        addSubview(rightContainer)
        leftContainer.addSubview(counter)
        leftContainer.addSubview(button)
        rightContainer.addSubview(requestsTableView)

        leftContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }

        counter.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        rightContainer.snp.makeConstraints {
            $0.leading.equalTo(leftContainer.snp.trailing)
            $0.trailing.top.bottom.equalTo(safeAreaLayoutGuide)
        }

        button.snp.makeConstraints {
            $0.top.equalTo(counter.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        requestsTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
