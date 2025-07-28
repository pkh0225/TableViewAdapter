# TableViewAdapter

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## No UITableView Delegate, DataSource
## NO Cell Register

<br>
<img alt="timetable" src="https://github.com/pkh0225/TableViewAdapter/blob/main/ScreenShot.png" width="333">

### ↑↑ please refer test sample project 👾👾


<br>

### sample data set
```swift
            
        let testData = TableViewAdapterData()
        for i in 0...10 {
            let sectionInfo = TVASectionInfo()
            testData.sectionList.append(sectionInfo)
            sectionInfo.header = TVAHeaderFooterInfo(cellType: TestHeaderFooterView.self)
                .setContentObj("@@ header @@ \(i)\n1247\nasdighj")
                .setActionClosure({ [weak self] (name, object) in
                    guard let self else { return }
                    guard let object = object else { return }

                    self.alert(title: "", message: "\(object) : \(name)")
                })

            sectionInfo.footer = TVAHeaderFooterInfo(cellType: TestHeaderFooterView.self)
                .setContentObj(" --- footer --- \(i)\nasdlk;fj\n213p4987")
                .setActionClosure({ [weak self] (name, object) in
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

                let cellInfo = TVACellInfo(cellType: TestTableViewCell.self)
                    .setContentObj(contentObj)
                    .setActionClosure({ [weak self] (name, object) in
                        guard let self else { return }
                        guard let object = object else { return }
                        self.alert(title: name, message: "\(object)")
                    })

                sectionInfo.cells.append(cellInfo)
            }

            self.tableView.adapterData = testData
            self.tableView.reloadData()
        
```
