//
//  ViewController.swift
//  Album Fetcher
//
//  Created by Friedrich Gräter on 03/03/15.
//  Copyright (c) 2015 Friedrich Gräter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate, UISearchBarDelegate {

	@IBOutlet private weak var searchView : UISearchBar?
	@IBOutlet private weak var containerView : UIView?

	private var downloadQueue : NSOperationQueue?
	private var tableView : ASTableView?
	private var albums : Array<Album>?
	
	
	// MARK: Global view setup
	
	override func viewDidLoad() {
		super.viewDidLoad()

		downloadQueue = NSOperationQueue()
	
		// Setup asynchronous table view
		tableView = ASTableView(frame: CGRectZero, style: UITableViewStyle.Plain);
		tableView!.asyncDelegate = self
		tableView!.asyncDataSource = self
		tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
		
		self.containerView!.addSubview(tableView!)
	}
	
	override func viewDidLayoutSubviews() {
		self.tableView!.frame = self.containerView!.bounds
	}

	override func prefersStatusBarHidden() -> Bool {
		return true
	}

	
	
	// MARK: Search field interaction
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		
		// Create search URL for iTunes Web API
		var searchTerm = searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
		var request = NSURLRequest(URL: NSURL(string: "http://itunes.apple.com/search?term=\(searchTerm!))&amp;media=music&entity=album&limit=200")!);
		
		// Request JSON data from iTunes
		NSURLConnection.sendAsynchronousRequest(request, queue: downloadQueue) { (response, data, error) -> Void in
			if let error = error {
				print(error)
				return
			}
			
			if let data = data {
				// Parse JSON data
				var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil) as! NSDictionary
				var unparsedAlbums = response["results"] as! [[String: AnyObject]]
				
				self.albums = unparsedAlbums.map {
					var title = ($0["collectionName"] as! String)
					var cover = ($0["artworkUrl100"] as! String)
					
					return Album(title: title, cover: cover)
				}
				
				// Update table view
				self.tableView?.reloadData()
			}
		}
	}
	
	
	
	// MARK: Table view
	
	func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
		return self.albums?.count ?? 0
	}
	
	func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
		return AlbumCellNode(album: self.albums![indexPath.indexAtPosition(1)])
	}
}
