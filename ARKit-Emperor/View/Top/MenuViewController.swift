//
//  MenuViewController.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/09.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let menu: [String] = ["Basic", "Stamp", "Doodle", "Picture", "Memo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func goToVC(_ storyboardName: String){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        show(vc, sender: self)
    }
}

extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            goToVC("Memo")
        default:
            break
        }
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = menu[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .red
        cell.textLabel?.font = UIFont(name: "StarJedi", size: 20)
        return cell
    }
}
