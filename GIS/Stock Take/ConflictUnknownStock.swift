//
//  ConflictUnknownStock.swift
//  GIS
//
//  Created by Apple Hawkscode on 17/12/20.
//

import UIKit


class ConflictUnknownStockCell: UITableViewCell {
    
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mSno: UILabel!
    @IBOutlet weak var mUknownView: UIView!
    @IBOutlet weak var mStockId: UILabel!
    @IBOutlet weak var mQuantity: UILabel!
    @IBOutlet weak var mIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

class ConflictUnknownStock: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var mUknownLine: UILabel!
    @IBOutlet weak var mConflictLine: UILabel!
    @IBOutlet weak var mAllLine: UILabel!
    @IBOutlet weak var mUnknownCounts: UILabel!
    @IBOutlet weak var mAllCounts: UILabel!
    
    @IBOutlet weak var mConflictCounts: UILabel!
    
    @IBOutlet weak var mBottomView: UIView!
    @IBOutlet weak var mConflictUnknownStockable: UITableView!
    
    @IBOutlet weak var mHeadingConflictUnknownLABEL: UILabel!
    var mConflictData = [String]()
    var mMasterData = [String]()

    @IBOutlet weak var mTotalCount: UILabel!
    var mCount = ""
    
    @IBOutlet weak var mConflictLABEL: UILabel!

    @IBOutlet weak var mShareLABEL: UILabel!
    
    @IBOutlet weak var mPrintLABEL: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {

        mHeadingConflictUnknownLABEL.text = "Conflict".localizedString + " / " + "Unknown".localizedString

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mMasterData = mConflictData
       
        let tap =  UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        mBottomView.isHidden = true
        mAllCounts.textColor = UIColor(named: "themeLightText")
        mConflictCounts.textColor = UIColor(named: "themeExtraLightText")
        mUnknownCounts.textColor = UIColor(named: "themeExtraLightText")
        mAllLine.backgroundColor = UIColor(named: "themeColor")
        mConflictLine.backgroundColor = UIColor(named: "themeExtraLightText")
        mUknownLine.backgroundColor = UIColor(named: "themeExtraLightText")
        mConflictUnknownStockable.delegate = self
        mConflictUnknownStockable.dataSource = self
        mConflictUnknownStockable.reloadData()
        mAllCounts.text = "All".localizedString + " (\(mConflictData.count))"
        
        var mConflictCount = [String]()
        for i in mConflictData {
            let mValue = i
            if !mValue.contains("UKN"){
                mConflictCount.append(mValue)
            }
        }
        mConflictCounts.text = "Conflict".localizedString + " (\(mConflictCount.count))"
        
        var mUnknownCount = [String]()
        for i in mConflictData {
            let mValue = i
            if mValue.contains("UKN"){
                mUnknownCount.append(mValue)
            }
        }
        mUnknownCounts.text = "Unknown".localizedString + " (\(mUnknownCount.count))"
    }
    
    @IBAction func mBack(_ sender: Any) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @IBAction func mShare(_ sender: Any) {
    }
    @IBAction func mFilterAll(_ sender: Any) {
        mConflictData = mMasterData
        mAllCounts.textColor = UIColor(named: "themeLightText")
        mConflictCounts.textColor = UIColor(named: "themeExtraLightText")
        mUnknownCounts.textColor = UIColor(named: "themeExtraLightText")
        mAllLine.backgroundColor = UIColor(named: "themeColor")
        mConflictLine.backgroundColor = UIColor(named: "themeExtraLightText")
        mUknownLine.backgroundColor = UIColor(named: "themeExtraLightText")
        mAllCounts.text = "All".localizedString + " (\(mConflictData.count))"
        mConflictData = mMasterData
        self.mConflictUnknownStockable.reloadData()
    }
    
    @IBAction func mFilterConflict(_ sender: Any) {
        mConflictData = mMasterData
        mConflictCounts.textColor = UIColor(named: "themeLightText")
        mAllCounts.textColor = UIColor(named: "themeExtraLightText")
        mUnknownCounts.textColor = UIColor(named: "themeExtraLightText")
        mConflictLine.backgroundColor = UIColor(named: "themeColor")
        mAllLine.backgroundColor = UIColor(named: "themeExtraLightText")
        mUknownLine.backgroundColor = UIColor(named: "themeExtraLightText")
        var mConflictCount = [String]()
        for i in mConflictData {
            let mValue = i
            if !mValue.contains("UKN"){
                mConflictCount.append(mValue)
            }
        }
        
        mConflictCounts.text = "Conflict".localizedString + " (\(mConflictCount.count))"
        mConflictData = mConflictCount
        self.mConflictUnknownStockable.reloadData()
        
    }
    
    
    @IBAction func mFilterUknown(_ sender: Any) {
        mConflictData = mMasterData
        mUnknownCounts.textColor = UIColor(named: "themeLightText")
        mConflictCounts.textColor = UIColor(named: "themeExtraLightText")
        mAllCounts.textColor = UIColor(named: "themeExtraLightText")
        mUknownLine.backgroundColor = UIColor(named: "themeColor")
        mConflictLine.backgroundColor = UIColor(named: "themeExtraLightText")
        mAllLine.backgroundColor = UIColor(named: "themeExtraLightText")
        var mUnknownCount = [String]()
        for i in mConflictData {
            let mValue = i
            if mValue.contains("UKN"){
                mUnknownCount.append(mValue)
            }
        }
        mUnknownCounts.text = "Unknown".localizedString + " (\(mUnknownCount.count))"
        mConflictData = mUnknownCount
        self.mConflictUnknownStockable.reloadData()
        
    }
    
    @IBAction func mPrint(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Test", bundle: nil)
        if let mPrint = storyBoard.instantiateViewController(withIdentifier: "PrintItem") as? PrintItem {
            self.navigationController?.pushViewController(mPrint, animated:true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mConflictData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        var cell  = UITableViewCell()
        
        if tableView == mConflictUnknownStockable {
            guard let  cells = tableView.dequeueReusableCell(withIdentifier: "ConflictUnknownStockCell") as? ConflictUnknownStockCell else {
                return cell
            }
            
            if mConflictData[indexPath.row].contains("UKN"){
                cells.mUknownView.isHidden =  true
                cells.mStockId.text = mConflictData[indexPath.row].replacingOccurrences(of: "UKN", with: "")

            }else{
                cells.mUknownView.isHidden =  false
                
                cells.mStockId.text = mConflictData[indexPath.row].trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
            }
            
            
            if (indexPath.row % 2 == 0) {
                cells.mView.backgroundColor = UIColor(named: "themeBackground")
            }else{
                cells.mView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)

            }
                         
            cells.mSno.text = "#\(indexPath.row + 1)"
            cell = cells
        }
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
        
        
    }

}
