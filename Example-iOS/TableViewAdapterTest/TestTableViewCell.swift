//
//  TestCellTableViewCell.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit

class TestTableViewCell: UITableViewCell, TableViewAdapterCellProtocol {
    var actionClosure: ActionClosure?

    @IBOutlet weak var label: UILabel!

    var data: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(data: Any?, subData: Any?, tableView: UITableView, indexPath: IndexPath) {
        guard let data = data as? String else { return }
        self.data = data
        self.label.text = data
    }

    @IBAction func onButton(_ sender: UIButton) {
        self.actionClosure?("button", self.data)
    }

    class func getSize(data: Any?, width: CGFloat, tableView: UITableView, indexPath: IndexPath) -> CGFloat {
        return self.fromXib(cache: true).frame.height
    }
}
