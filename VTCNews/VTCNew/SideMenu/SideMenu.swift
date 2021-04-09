//
//  SideMenu.swift
//  VTVNew
//
//  Created by Nguyễn Văn Chiến on 2/23/21.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
    var img = String()
    var imgDown = String()
}

class SideMenu: UIViewController {
    var tableViewData = [cellData]()
    
    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UINib(nibName: "CellSideMenu", bundle: nil), forCellReuseIdentifier: "CellSideMenu")
        tbl.register(UINib(nibName: "CellLogoSideMenu", bundle: nil), forCellReuseIdentifier: "CellLogoSideMenu")
        tbl.register(UINib(nibName: "CellBotSideMenu", bundle: nil), forCellReuseIdentifier: "CellBotSideMenu")
        tableViewData = [cellData(opened: false, title: "", sectionData: [], img: "", imgDown: ""),
                         cellData(opened: false, title: "Trang chủ", sectionData: [], img: "icSMHome", imgDown: ""),
                         cellData(opened: false, title: "Tin tức", sectionData: ["Tin mới"], img: "icSMNew", imgDown: "icSMDown"),
                         cellData(opened: false, title: "Video", sectionData: [], img: "icSMVideo", imgDown: ""),
                         cellData(opened: false, title: "Audio", sectionData: ["Podcast","Sách nói","Âm nhạc"], img: "icSMAudio", imgDown: "icSMDown"),
                         cellData(opened: false, title: "", sectionData: [], img: "", imgDown: "")]
    }
}

extension SideMenu: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return scale * 100
        } else if indexPath.section == 5 {
            return scale * 300
        } else {
            
            return scale * 70
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellLogoSideMenu", for: indexPath) as! CellLogoSideMenu
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBotSideMenu", for: indexPath) as! CellBotSideMenu
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellSideMenu", for: indexPath) as! CellSideMenu
                cell.lblTitle.text = tableViewData[indexPath.section].title
                cell.img.image = UIImage(named: tableViewData[indexPath.section].img)
                cell.imgDown.image = UIImage(named: tableViewData[indexPath.section].imgDown)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellSideMenuChildren", for: indexPath) as! CellSideMenuChildren
                cell.lblTitle.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
                cell.img.image = UIImage(named: "")
                cell.imgDown.image = UIImage(named: "")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("VisitTabHome"), object: nil)
            dismiss(animated: true, completion: nil)
        case 2:
            if indexPath.row == 1 {
                NotificationCenter.default.post(name: NSNotification.Name("VisitTabNew"), object: nil)
                dismiss(animated: true, completion: nil)
            }
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("VisitTabVideo"), object: nil)
            dismiss(animated: true, completion: nil)
        case 4:
            if indexPath.row == 1 {
                NotificationCenter.default.post(name: NSNotification.Name("VisitTabAudio"), object: nil)
                dismiss(animated: true, completion: nil)
            } else if indexPath.row == 2 {
                NotificationCenter.default.post(name: NSNotification.Name("VisitTabAudio"), object: nil)
                dismiss(animated: true, completion: nil)
            } else if indexPath.row == 3 {
                NotificationCenter.default.post(name: NSNotification.Name("VisitTabAudio"), object: nil)
                dismiss(animated: true, completion: nil)
            }
        default:
            print("aaa")
        }
        
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
        
    }
    
}
