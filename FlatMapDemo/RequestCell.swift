import SnapKit
import UIKit

class RequestCell: UITableViewCell {

    let urlLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.text = "Some URL"
        label.lineBreakMode = .byTruncatingHead

        return label
    }()

    let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "200 OK"

        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "200 ms"
        label.textAlignment = .right

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(urlLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(timeLabel)

        urlLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(urlLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(urlLabel)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }

        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(statusLabel.snp.trailing)
            $0.top.bottom.equalTo(statusLabel)
            $0.trailing.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

}
