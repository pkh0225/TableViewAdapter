//
//  TestHeaderFooterCell.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit

class TestHeaderFooterView: UITableViewHeaderFooterView, TableViewAdapterHeaderFooterProtocol {
    var actionClosure: ActionClosure?
    
    @IBOutlet weak var label: UILabel!

    var data: String = ""

    func configure(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath, actionClosure: ActionClosure?) {
        guard let data = data as? String else { return }
        self.data = data
        self.label.text = data
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
