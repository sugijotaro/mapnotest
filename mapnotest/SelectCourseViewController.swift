//
//  TableViewController.swift
//  mapnotest
//
//  Created by JotaroSugiyama on 2020/04/23.
//  Copyright © 2020 JotaroSugiyama. All rights reserved.
//

import UIKit

class SelectCourseViewController: UITableViewController, UINavigationBarDelegate{
    
    var str: Array<Array<String>> = []
    
    private let items = [
        (type: "中野", members: ["中野グルメ巡りコース", "中野サブカル巡りコース"]),
        (type: "高尾山", members: ["あ"]),
        (type: "上野", members: ["い"]),
        (type: "お台場", members: ["う"]),
        (type: "川越", members: ["え"]),
        (type: "御茶ノ水", members: ["お"])
    ]
    
    private var openedSections = Set<Int>()

    var strNumber :Int = 0
    
    private var previewingViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "観光する"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonHiddenItem: .Previous, target: self, action: #selector(barButtonTapped(_:)))
        
        
        if let csvPath = Bundle.main.path(forResource: "course", ofType: "csv") {
            do {
                var csvString =  try NSString(contentsOfFile: csvPath, encoding: String.Encoding.utf8.rawValue) as String
                csvString = csvString.replacingOccurrences(of: "\r", with: "")
                let rowArray:Array = csvString.components(separatedBy: "\n")

                rowArray.forEach {
                    let items = $0.components(separatedBy: ",")
                    str.append(items)
                }
            } catch {
                // エラー
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sectionHeaderDidTap(_ sender: UIGestureRecognizer) {
        if let section = sender.view?.tag {
            if openedSections.contains(section) {
                openedSections.remove(section)
            } else {
                openedSections.insert(section)
            }

            tableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if openedSections.contains(section) {
            return items[section].members.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.section].members[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].type
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UITableViewHeaderFooterView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(sectionHeaderDidTap(_:)))
        view.addGestureRecognizer(gesture)
        view.tag = section
        return view
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("section: \(indexPath.section) , row: \(indexPath.row)")
        
        for i in 1 ... str.count - 1 {
            if Int(str[i][0]) == indexPath.section && Int(str[i][1]) == indexPath.row {
                strNumber = i
                self.performSegue(withIdentifier: "toCourseView", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseView" {
            let nextView = segue.destination as! CourseViewController
            
            print("strNumber: \(strNumber)")
            print("str[strNumber] :\(str[strNumber][3])")
            
            nextView.courseNameString = str[strNumber][3]
            nextView.locationNameString = str[strNumber][2]
            nextView.textViewString = str[strNumber][4]
        }
    }
}


enum UIBarButtonHiddenItem: Int {
    case Previous = 101
    case Next     = 102
    case Up       = 103
    case Down     = 104
    case Locate   = 100
    case Trash    = 110
    func convert() -> UIBarButtonItem.SystemItem {
        return UIBarButtonItem.SystemItem(rawValue: self.rawValue)!
    }
}

extension UIBarButtonItem {
    convenience init(barButtonHiddenItem item:UIBarButtonHiddenItem, target: AnyObject?, action: Selector) {
        self.init(barButtonSystemItem: item.convert(), target:target, action: action)
    }
}
