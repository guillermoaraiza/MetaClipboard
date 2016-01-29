//
//  ViewController.swift
//  Meta Clipboard
//
//  Created by Guillermo A Araiza Torres on 26/01/16.
//  Copyright © 2016 Disforma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var keyValueStoreDidChangeObserver: AnyObject?
    var clipboardDidChangeObserver: AnyObject?
    var metaClipboard: MetaClipboard = MetaClipboard()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var label: UILabel!
    @IBOutlet var sendButton: UIButton!
              var refresher: UIRefreshControl!
    
    // This is how we send the data to the clipboard.
    @IBAction func sendDataToClipboard(sender: AnyObject) {
        
        sendDataToClipboard()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table View Delegate.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // MetaClipboard Update.
        metaClipboard.update()
        
        sendButton.layer.borderWidth = 1.5
        sendButton.layer.borderColor = UIColor(red:105/255,green:152/255,blue:252/255,alpha:1).CGColor
        sendButton.backgroundColor   = UIColor(red:105/255,green:176/255,blue:252/255,alpha: 1)
        sendButton.tintColor         = UIColor.whiteColor()
        
        
        label.layer.borderWidth      = 1.75
        label.layer.borderColor      = UIColor(red:80/255,green:108/255,blue:133/255,alpha:0.7).CGColor
        label.backgroundColor        = UIColor(red:133/255,green:159/255,blue:182/255,alpha:0.7)
        label.layer.cornerRadius     = 7
        
        
        // Create Observer for KeyValueDidChange
        keyValueStoreDidChangeObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
            
            self.updateMetaClipboard()
            
        })
        
        // Create Observer for KeyValueDidChange
        clipboardDidChangeObserver = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
            print("Become Active")
            self.updateLocalClipboard()
            
        })
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Refresh")
        refresher.addTarget(self, action: "refreshClipboard", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        
    }
    
    
    func refreshClipboard(){
        
        metaClipboard.update()          // Update the data
        updateLocalClipboard()          // Update the local clipboard.
        tableView.reloadData()          // Reload data in clipboard
        refresher.endRefreshing()       // En Refresher
    }
    
    
    func updateMetaClipboard(){
        
        metaClipboard.update()
        if let theString = metaClipboard.first() as String? {
            
            copyToClipboard(theString)
            
        }
        tableView.reloadData()
    }
    
    
    func sendDataToClipboard(){
        
        if let clipboardString:String? = UIPasteboard.generalPasteboard().string {
            
            metaClipboard.append(clipboardString!)
            copyToClipboard(clipboardString!)
            
        }
        tableView.reloadData()
        
    }
    
    
    
    
    func copyToClipboard(theString: String){
        
        label.text = theString
        UIPasteboard.generalPasteboard().string = theString
        print("Clipboard Updated")
        
    }
    
    func updateLocalClipboard(){
        if let clipboardString:String? = UIPasteboard.generalPasteboard().string {
            label.text = clipboardString
        }else{
            label.text = "Your clipboard is not text."
        }
    }

    
    
    
    
    
    func numberOfSectionsInTableView(tableView:UITableView) -> Int {
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metaClipboard.metaClipboardItems.count // your number of cell here
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = metaClipboard.metaClipboardItems[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let clipboardString = metaClipboard.find(indexPath.row)
        tableView.reloadData()
        copyToClipboard(clipboardString)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


}

