//
//  ViewController.swift
//  TableViewAdapterTest
//
//  Created by 박길호(파트너) - 서비스개발담당App개발팀 on 10/23/24.
//

import UIKit
import TableViewAdapter

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isUsedCacheSize = true

        let testData = TableViewAdapterData()
        for i in 0...10 {
            let sectionInfo = TVASectionInfo()
            sectionInfo.header = TVAHFInfo(TestHeaderFooterView.self)
                .contentObj("@@ header @@ \(i)\n1247\nasdighj")
                .actionClosure({ [weak self] (name, object) in
                    guard let self else { return }
                    guard let object = object else { return }

                    self.alert(title: "", message: "\(object) : \(name)")
                })

            sectionInfo.footer = TVAHFInfo(TestHeaderFooterView.self)
                .contentObj(" --- footer --- \(i)\nasdlk;fj\n213p4987")
                .actionClosure({ [weak self] (name, object) in
                    guard let self else { return }
                    guard let object = object else { return }
                    self.alert(title: "", message: "\(object) : \(name)")
                })

            for j in 0...3 {
                let contentObj: String
                if #available(iOS 14.0, *) {
                    // cell auto size test
                    contentObj = "cell (\(i) : \(j))\n12351235\n1235512345"
                }
                else {
                    // cell fix size
                    contentObj = "cell (\(i) : \(j))"
                }

                let cellInfo = TVACellInfo(TestTableViewCell.self)
                    .contentObj(contentObj)
                    .actionClosure({ [weak self] (name, object) in
                        guard let self else { return }
                        guard let object = object else { return }
                        self.alert(title: name, message: "\(object)")
                    })

                sectionInfo.addCell(cellInfo)
            }
            testData.addScetion(sectionInfo)

            self.tableView
                .adapterData(testData)
                .reloadData()
        }
    }

    func alert(title: String, message: String, addAction: (()->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            addAction?()
        })
        self.present(alert, animated: true, completion: nil)
    }
}
