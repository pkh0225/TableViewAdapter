//
//  TestHeaderFooterCell.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit

class TestHeaderFooterView: UITableViewHeaderFooterView, TVAHeadFooterFProtocol {
    var actionClosure: ((_ name: String, _ object: Any?) -> Void)?
    
    @IBOutlet weak var label: UILabel!

    var data: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath) {
        guard let data = data as? String else { return }
        self.data = data
        self.label.text = data
        self.contentView.backgroundColor = #colorLiteral(red: 0.9060257077, green: 1, blue: 0.8165706992, alpha: 1)
    }

    func didSelect(tableView: UITableView, indexPath: IndexPath) {

    }

    class func getSize(data: Any?, width: CGFloat, tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        return 50
    }

    @IBAction func onBuitton(_ sender: UIButton) {
        self.actionClosure?("button", data)
    }
}
