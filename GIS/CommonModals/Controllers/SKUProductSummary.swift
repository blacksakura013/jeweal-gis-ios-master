//
//  SKUProductSummary.swift
//  GIS
//
//  Created by MacBook Hawkscode  on 13/12/22.
//  Copyright © 2022 Hawkscode. All rights reserved.
//

import UIKit
import Alamofire
class SKUStonesCell : UITableViewCell {
    
    
    @IBOutlet weak var mStoneName: UILabel!
    
    @IBOutlet weak var mShapeName: UILabel!
    
    @IBOutlet weak var mCut: UILabel!
    @IBOutlet weak var mClarity: UILabel!
    @IBOutlet weak var mColor: UILabel!
    @IBOutlet weak var mSize: UILabel!
    
    @IBOutlet weak var mPcs: UILabel!
    @IBOutlet weak var mWeight: UILabel!
    @IBOutlet weak var mSetting: UILabel!
    @IBOutlet weak var mCertificateName: UILabel!
    
    @IBOutlet weak var mOpenLinkButton: UIButton!
    @IBOutlet weak var mCertificateNumber: UILabel!
    
    @IBOutlet weak var mStoneLABEL: UILabel!
    @IBOutlet weak var mShapeLABEL: UILabel!
    @IBOutlet weak var mCutLABEL: UILabel!
    @IBOutlet weak var mClarityLABEL: UILabel!
    @IBOutlet weak var mColorLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mPcsLABEL: UILabel!
    
    @IBOutlet weak var mWeightLABEL: UILabel!
    @IBOutlet weak var mSettingLABEL: UILabel!
    @IBOutlet weak var mCertificateLABEL: UILabel!
    
    
    
}

class SKUProductSummary: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableHeight: NSLayoutConstraint!
    @IBOutlet weak var mProductImage: UIImageView!
    @IBOutlet weak var mMetatag: UILabel!
    @IBOutlet weak var mProductInfo: UILabel!
    @IBOutlet weak var mProductId: UILabel!
    @IBOutlet weak var mSKUName: UILabel!
    @IBOutlet weak var mStockId: UILabel!
    @IBOutlet weak var mVariantStatus: UIImageView!
    @IBOutlet weak var mCurrencyFlag: UIImageView!
    @IBOutlet weak var mPrice: UILabel!
    @IBOutlet weak var mLocation: UILabel!
    @IBOutlet weak var mMetal: UILabel!
    @IBOutlet weak var mColor: UILabel!
    @IBOutlet weak var mSize: UILabel!
    @IBOutlet weak var mGrossWeight: UILabel!
    @IBOutlet weak var mNetWeight: UILabel!
    
    @IBOutlet weak var mStoneTable: UITableView!
    
    private var mProductData = NSMutableArray()
    var mOriginalData = NSArray()
    var mStoneData = NSArray()
    
    var mKey = ""
    
    
    @IBOutlet weak var mProductIdLABEL: UILabel!
    @IBOutlet weak var mSKULABEL: UILabel!
    @IBOutlet weak var mStockIdLABEL: UILabel!
    @IBOutlet weak var mPriceLABEL: UILabel!
    @IBOutlet weak var mLocationLABEL: UILabel!
    @IBOutlet weak var mMetalLABEL: UILabel!
    @IBOutlet weak var mColorLABEL: UILabel!
    @IBOutlet weak var mSizeLABEL: UILabel!
    @IBOutlet weak var mGrossWeightLABEL: UILabel!
    @IBOutlet weak var mNetWeightLABEL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mUserLoginToken = UserDefaults.standard.string(forKey: "token")
        mUserLoginTokenPos = UserDefaults.standard.string(forKey: "token_pos")
        
        mProductIdLABEL.text = "Product ID".localizedString
        mSKULABEL.text = "SKU".localizedString
        mStockIdLABEL.text = "Stock ID".localizedString
        mPriceLABEL.text = "Price".localizedString
        mLocationLABEL.text = "Location".localizedString
        mMetalLABEL.text = "Metal".localizedString
        mColorLABEL.text = "Color".localizedString
        mSizeLABEL.text = "Size".localizedString
        mGrossWeightLABEL.text = "Gross Wt".localizedString
        mNetWeightLABEL.text = "Net Wt".localizedString
        
        
        if !mKey.isEmpty {
            CommonClass.showFullLoader(view: self.view)
            let params = ["id": mKey]
            
            mGetData(url: mProductInformation,headers: sGisHeaders,  params: params) { response , status in
                CommonClass.stopLoader()
                if status {
                    if let data = response.value(forKey: "data") as? NSDictionary {
                        self.mSetData(mData: data)
                    }else{
                        CommonClass.showSnackBar(message: "Product info not available!")
                    }
                }else{
                    CommonClass.showSnackBar(message: "Product info not available!")
                    
                }
                
            }
        }else{
            mProductData = NSMutableArray(array: mOriginalData )
            if let mData = mProductData[0] as? NSDictionary {
                mSetData(mData: mData)
            }
        }
        
        
        
        
    }
    
    func mSetData(mData: NSDictionary) {
        mProductImage.downlaodImageFromUrl(urlString: "\(mData.value(forKey: "main_image") ?? "" )")
        mMetatag.text = "\(mData.value(forKey: "Matatag") ?? "")"
        mProductInfo.text = "\(mData.value(forKey: "item_name") ?? "")"
        mProductId.text = "\(mData.value(forKey: "ID") ?? "")"
        mSKUName.text = "\(mData.value(forKey: "SKU") ?? "")"
        mStockId.text = "\(mData.value(forKey: "stock_id") ?? "")"
        mPrice.text = "\(mData.value(forKey: "price") ?? "")"
        mLocation.text = "\(mData.value(forKey: "location_name") ?? "")"
        mMetal.text = "\(mData.value(forKey: "metal_name") ?? "")"
        mColor.text = "\(mData.value(forKey: "color") ?? "")"
        mSize.text = "\(mData.value(forKey: "size_name") ?? "")"
        mGrossWeight.text = "\(mData.value(forKey: "GrossWt") ?? "")"
        mNetWeight.text = "\(mData.value(forKey: "NetWt") ?? "")"
        
        if let mStonesArr = mData.value(forKey: "stoneData") as? NSArray, mStonesArr.count > 0 {
            mStoneData = mStonesArr
        } else {
            return
        }
        
        mStoneTable.delegate = self
        mStoneTable.dataSource = self
        mStoneTable.reloadData()
        mStoneTable.isScrollEnabled = false
        mStoneTable.separatorColor = UIColor(named: "themeTextExtraLight1")
        mStoneTable.separatorStyle = .singleLine
    }
    
    @IBAction func mOpenLink(_ sender: UIButton) {
        if let mLinkData = mStoneData[sender.tag] as? NSDictionary {
            if let mLink = mLinkData.value(forKey: "certificateLink") as? String {
                
                if mLink != "" {
                    if let url = URL(string: mLink) {
                        UIApplication.shared.open(url)
                    }
                }else{
                    CommonClass.showSnackBar(message: "No links found!")
                }
                
            }else{
                CommonClass.showSnackBar(message: "No links found!")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mStoneData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        guard let cells = tableView.dequeueReusableCell(withIdentifier: "SKUStonesCell") as? SKUStonesCell else {
            return UITableViewCell()
        }
        
        cells.mStoneLABEL.text = "Stone".localizedString
        cells.mShapeLABEL.text = "Shape".localizedString
        cells.mCutLABEL.text = "Cut".localizedString
        cells.mClarityLABEL.text = "Clarity".localizedString
        cells.mColorLABEL.text = "Color".localizedString
        cells.mSizeLABEL.text = "Size".localizedString
        cells.mPcsLABEL.text = "Pcs".localizedString
        cells.mWeightLABEL.text = "Weight".localizedString
        cells.mSettingLABEL.text = "Setting".localizedString
        cells.mCertificateLABEL.text = "Certificate".localizedString
        
        if let mData = mStoneData[indexPath.row] as? NSDictionary {
            
            if var pointer = mData.value(forKey: "Pointer") as? String {
                if pointer == "0.0" {
                    pointer = ""
                    cells.mSize.text = "\(mData.value(forKey: "Size") ?? "")"
                }else{
                    cells.mSize.text = "\(mData.value(forKey: "Size") ?? "")" +  " - \(pointer)"
                }
            }else{
                cells.mSize.text = "\(mData.value(forKey: "Size") ?? "")"
            }
            cells.mStoneName.text = "\(mData.value(forKey: "stone") ?? "")"
            cells.mShapeName.text = "\(mData.value(forKey: "shape") ?? "")"
            cells.mCut.text = "\(mData.value(forKey: "cut") ?? "")"
            cells.mClarity.text = "\(mData.value(forKey: "clarity") ?? "")"
            cells.mPcs.text = "\(mData.value(forKey: "Pcs") ?? "")"
            cells.mSetting.text = "\(mData.value(forKey: "setting_type") ?? "")"
            cells.mColor.text = "\(mData.value(forKey: "color") ?? "")"
            
            cells.mCertificateName.text = "\(mData.value(forKey: "certificateName") ?? "")"
            cells.mCertificateNumber.text = "\(mData.value(forKey: "certificateNo") ?? "")"
            cells.mOpenLinkButton.tag = indexPath.row
            cells.mWeight.text = "\(mData.value(forKey: "Cts") ?? "")"
        }
        self.mStoneTable.layoutIfNeeded()
        self.mTableHeight.constant = self.mStoneTable.contentSize.height + 300
        return cells
    }
    
    
    
    
}
