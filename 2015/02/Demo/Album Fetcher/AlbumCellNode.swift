//
//  AlbumCellNode.swift
//  Album Fetcher
//
//  Created by Friedrich Gräter on 03/03/15.
//  Copyright (c) 2015 Friedrich Gräter. All rights reserved.
//

import Foundation

class AlbumCellNode : ASCellNode, ASMultiplexImageNodeDataSource {
	
	// Layout constants
	let outerSpacing	= CGFloat(16)
	let textSize		= CGFloat(20)
	
	// Expected image size
	let imageWidth			: CGFloat
	let nativeImageWidth	: CGFloat
	
	// Model
	let album		: Album;
	
	// Views
	let imageNode	: ASMultiplexImageNode;
	let textNode	: ASTextNode;
	
	
	// MARK : Initialization
	
	init(album: Album) {
		// Setup constant properties
		self.album = album;
		
		imageNode = ASMultiplexImageNode(cache: nil, downloader: ASBasicImageDownloader())
		textNode = ASTextNode()

		// Determine required image size
		nativeImageWidth = max(UIScreen.mainScreen().nativeBounds.width, UIScreen.mainScreen().nativeBounds.height) / 2
		imageWidth = nativeImageWidth / UIScreen.mainScreen().scale
		
		super.init()

		// Setup nodes
		setUpImageNode()
		setUpTextNode()
		
		// Add nodes to tree
		self.addSubnode(imageNode)
		self.addSubnode(textNode)
	}

	
	
	// MARK: Node setup
	
	func setUpImageNode()
	{
		// Setup Image
		imageNode.dataSource = self
		
		// Placeholder color
		imageNode.backgroundColor = UIColor.grayColor()
		
		// Pre-load various variants depending on network performance (1x, 0.2x, 0.1x)
		imageNode.imageIdentifiers = [1, 5, 10].map({ "\(UInt(self.nativeImageWidth / $0))" })
		imageNode.downloadsIntermediateImages = true
		
		// Apply some blur effects
		imageNode.imageModificationBlock = { (image: UIImage!) -> UIImage! in
			let blurHeight = (self.textSize * 3) * (image.size.width / self.nativeImageWidth)
			return image.applyBlurWithRadius(32, tintColor: nil, saturationDeltaFactor: 0.5, clipRect: CGRectMake(0, 0, image.size.width, blurHeight))
		}
	}
	
	func setUpTextNode() {
		let attributes = [
			NSForegroundColorAttributeName:		UIColor.whiteColor(),
			NSFontAttributeName:				UIFont.systemFontOfSize(textSize),
		]

		// Set string and truncation
		textNode.attributedString = NSAttributedString(string: album.title, attributes: attributes)
		textNode.truncationMode = NSLineBreakMode.ByTruncatingTail
		
		// Add a shadow
		textNode.shadowColor = UIColor.blackColor().CGColor
		textNode.shadowRadius = 4
		textNode.shadowOffset = CGSizeZero
		textNode.shadowOpacity = 1
	}
	
	
	
	// MARK: Layouting
	
	override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
		// Calculate sizes for subitems
		imageNode.measure(CGSizeMake(min(imageWidth, constrainedSize.width), imageWidth))
		textNode.measure(CGSizeMake(constrainedSize.width - outerSpacing * 2, self.textSize * 2))

		// Determine size of overall item
		return CGSizeMake(constrainedSize.width, imageWidth)
	}
	
	override func layout() {
		let textSize = textNode.calculatedSize
		
		// Set layout of subnodes
		imageNode.frame = CGRectMake(CGFloat(0), CGFloat(0), imageWidth, imageWidth)
		textNode.frame = CGRectMake(outerSpacing, imageWidth - textSize.height, textSize.width, textSize.height)
	}
	
	
	// MARK: Image loading
	
	func multiplexImageNode(imageNode: ASMultiplexImageNode!, URLForImageIdentifier imageIdentifier: AnyObject!) -> NSURL! {
		return NSURL(string: album.cover.stringByReplacingOccurrencesOfString("100x100", withString: "\(imageIdentifier)x\(imageIdentifier)"))!
	}
	

}
