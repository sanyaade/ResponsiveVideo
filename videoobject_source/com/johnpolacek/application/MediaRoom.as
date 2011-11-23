﻿package com.johnpolacek.application{	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.BitmapDataChannel;	import flash.display.DisplayObject;	import flash.display.Loader;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageDisplayState;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.MouseEvent;	import flash.events.TextEvent;	import flash.media.SoundMixer;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.text.StyleSheet;	import com.asual.SWFAddress;	import com.asual.SWFAddressEvent;	import com.google.analytics.AnalyticsTracker; 	import com.google.analytics.GATracker;	import com.greensock.TweenLite;	import com.greensock.easing.Expo;	import com.millermedeiros.swffit.SWFFit;	import com.millermedeiros.swffit.SWFFitEvent;	import com.johnpolacek.application.SiteFormat;	import com.johnpolacek.components.ContentPanel;	import com.johnpolacek.components.ContentPanelFormat;	import com.johnpolacek.components.ContentContainer;	import com.johnpolacek.display.ContentDisplayCreator;	import com.johnpolacek.display.ImageDisplay;	import com.johnpolacek.display.VideoDisplay;	import com.johnpolacek.events.LightboxEvent;	import com.johnpolacek.events.UIEvent;	import com.johnpolacek.events.TrackEvent;	import com.johnpolacek.shapes.RectangleShape;	import com.johnpolacek.text.FontsLoader;	import com.johnpolacek.text.HTMLTextBlock;	import com.johnpolacek.ui.AccordionMenu;	import com.johnpolacek.ui.BasicButton;	import com.johnpolacek.ui.BasicButtonMenu;	import com.johnpolacek.ui.FullScreenScrollbar;	 /** * An xml-based full-screen flash site template designed for loading media. *  * @version  * <b>27 Apr 2010</b>  <br>  * * @author John Polacek, john@johnpolacek.com */	 		public class MediaRoom extends MovieClip	{				/** Navigation button menu **/		public var nav:AccordionMenu;		/** Contains content for footer **/		public var footer:ContentPanel;		/** Graphic aligned to bottom right corner **/		public var snipe:ImageDisplay;		/** Stylesheet for all text **/		public var textStyleSheet:StyleSheet;		/** Current media being displayed **/		public var currMedia:Sprite;		/** Previous media being displayed **/		public var prevMedia:Sprite;		/** Height of the content area (dynamic) **/		public var contentHeight:int;		/** XML file for site **/		public var siteXML:XML;		/** Content creator object **/		public var contentCreator = new ContentDisplayCreator();		/** Google Analytics tracker **/		public var tracker:AnalyticsTracker;		/** Tracking code for Google Analytics tracker **/		public var trackingCode:String;				private var minContentHeight:int = 480;		private var mediaHeight:int;		private var mediaWidth:int;		private var mediaTransitionComplete:Boolean = false;		// Current page address for media		private var addressID:String;						public function MediaRoom()		{			init();		}			//--------------------------------------------------------------------------    //    //  SEQUENCED LOADING / BUILDING    //    //--------------------------------------------------------------------------				/** Set initial params and add top-level display objects/event listeners **/		public function init():void		{			trace("MediaRoom.init");			stage.align = StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.addEventListener(Event.RESIZE, onStageResize);			loadSiteXML("xml/site.xml");		}				//----------------------------------  		//  LOAD SITE XML    	//----------------------------------				/** Loads main site xml file which contains all site configuration settings. **/		public function loadSiteXML(url:String):void		{			trace("MediaRoom.loadSiteXML");			var loader:URLLoader = new URLLoader(); 			loader.addEventListener(IOErrorEvent.IO_ERROR, onSiteXMLLoadError);			loader.addEventListener(Event.COMPLETE, onSiteXMLLoadComplete); 			// add random number var to end of url to clear cache			loader.load(new URLRequest(url + "?rand=" + Math.random()));		}				/** Site XML load error handler **/		public function onSiteXMLLoadError(event:IOErrorEvent):void		{			trace("site.xml file could not be found. Site could not be loaded");		}				/** After site xml loads, initiates next action **/		public function onSiteXMLLoadComplete(event:Event):void		{			trace("MediaRoom.onSiteXMLLoadComplete");			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onSiteXMLLoadError);			event.target.removeEventListener(Event.COMPLETE, onSiteXMLLoadComplete); 						siteXML = XML(event.target.data);						// set content path & minimum height			contentCreator.contentPath = String(siteXML.content.@path);			if (int(siteXML.content.@height) > 200)				minContentHeight = int(siteXML.content.@height);						// tracking			if (String(siteXML.tracking.code)!="")			{				trackingCode = String(siteXML.tracking.code);				initTracking();				addEventListener(TrackEvent.TRACK, trackEventHandler);			}						SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);						loadCSS();		}				//----------------------------------  		//  FONTS    	//----------------------------------				/** Loads css  **/		public function loadCSS():void		{			var loader:URLLoader = new URLLoader(); 			loader.addEventListener(IOErrorEvent.IO_ERROR, onCSSLoadError);			loader.addEventListener(Event.COMPLETE, onCSSLoadComplete); 			loader.load(new URLRequest("css/styles.css")); 		}				/** CSS load error handler **/		public function onCSSLoadError(event:IOErrorEvent):void		{			trace("css/styles.css not found. \n Default styling will be used. Embedded fonts will not appear.");			onFontsLoadComplete(null);		}				/** After CSS load completes, load runtime fonts **/		public function onCSSLoadComplete(event:Event):void		{			trace("MediaRoom.onCSSLoadComplete");			event.target.removeEventListener(IOErrorEvent.IO_ERROR, onCSSLoadError);			event.target.removeEventListener(Event.COMPLETE, onCSSLoadComplete); 			textStyleSheet = new StyleSheet();    		textStyleSheet.parseCSS(event.target.data);			var fonts = [];			var fontsPath:String = String(siteXML.fonts.@path);			for each (var fontURL:String in siteXML.fonts..font) 			{				fonts.push(fontsPath+fontURL+".swf");			}						if (fonts.length > 0)				loadFonts(fonts);			else 				onFontsLoadComplete(null);		}				/** Loads runtime fonts **/		public function loadFonts(fontsArray:Array):void		{			trace("MediaRoom.loadFonts");			var loader:FontsLoader = new FontsLoader();			loader.addEventListener(Event.COMPLETE, onFontsLoadComplete);			loader.loadFonts(fontsArray);					}				/** Load first content section after fonts load complete **/		public function onFontsLoadComplete(event:Event):void		{			trace("MediaRoom.onFontsLoadComplete");			if (event)				event.target.removeEventListener(Event.COMPLETE, onFontsLoadComplete);			loadRuntimeAssets();		}				/** Loads runtime assets from runtime.swf (if it exists) **/		private function loadRuntimeAssets():void		{			trace("MediaRoom.loadRuntimeAssets");			var loader:Loader = new Loader();			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onRuntimeAssetsLoadComplete);			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onRuntimeAssetsLoadError);			loader.load(new URLRequest("runtime.swf"));		}				/** Catches load error is runtime.swf does not exist **/		public function onRuntimeAssetsLoadError(event:IOErrorEvent):void		{			trace("No runtime assets to load: runtime.swf not found");			if (event)			{				event.target.removeEventListener(Event.COMPLETE, onRuntimeAssetsLoadComplete);				event.target.removeEventListener(IOErrorEvent.IO_ERROR, onRuntimeAssetsLoadError);			}			onRuntimeAssetsLoadComplete();		}				/** Load complete handler for runtime.swf **/		public function onRuntimeAssetsLoadComplete(event:Event = null):void		{			trace("MediaRoom.onRuntimeAssetsLoaded");			if (event)			{				event.target.removeEventListener(Event.COMPLETE, onRuntimeAssetsLoadComplete);				event.target.removeEventListener(IOErrorEvent.IO_ERROR, onRuntimeAssetsLoadError);			}			loadFooter();			createNav();		}				//----------------------------------  		//  FOOTER    	//----------------------------------				/** Loads footer **/		public function loadFooter():void		{			trace("MediaRoom.loadFooter");			footer = new ContentPanel();			footer.addEventListener(Event.COMPLETE, onFooterLoadComplete);			footer.styleSheet = textStyleSheet;			footer.contentPath = String(siteXML.content.@path);			var footerFormat:ContentPanelFormat = new ContentPanelFormat();			footerFormat.setFormatFromXML(XML(siteXML.footer));			footer.setFormat(footerFormat);			footer.loadElementFromXML("xml/footer.xml");					}				/** Footer load error handler **/		public function onFooterLoadError(event:IOErrorEvent):void		{			trace("footer.xml not found. \n No footer is created.");			onFooterLoadComplete();		}				/** Actions initiated after footer load is complete **/		public function onFooterLoadComplete(event:Event = null):void		{			trace("MediaRoom.onFooterLoadComplete");			footer.removeEventListener(Event.COMPLETE, onFooterLoadComplete);			footer.visible = false;			footer.y = stage.stageHeight;			footer.background.width = stage.stageWidth;			addChild(footer);			loadSnipe();		}				//----------------------------------  		//  SNIPE    	//----------------------------------		public function loadSnipe():void		{			trace("MediaRoom.loadSnipe");			var snipeURL:String = String(siteXML.snipe);			if (snipeURL != "")			{				snipe = new ImageDisplay(String(siteXML.content.@path) + snipeURL);				snipe.addEventListener(Event.COMPLETE, onSnipeLoadComplete);				snipe.addEventListener(IOErrorEvent.IO_ERROR, onSnipeLoadComplete);			}			else				onSnipeLoadComplete();		}		/** Header complete handler **/		public function onSnipeLoadComplete(event:Event = null):void		{			trace("MediaRoom.onSnipeLoadComplete");			if (event)			{				snipe.removeEventListener(Event.COMPLETE, onSnipeLoadComplete);				snipe.removeEventListener(IOErrorEvent.IO_ERROR, onSnipeLoadComplete);				snipe.x = stage.stageWidth - snipe.width + int(siteXML.snipe.@offsetx);				snipe.y = int(siteXML.snipe.@offsety);				footer.addChild(snipe);				if (snipe.y < 0)					footer.y -= snipe.y;			}			transitionNavIn();			if (mediaTransitionComplete)				transitionFooter();		}			//--------------------------------------------------------------------------    //    //  NAVIGATION    //    //--------------------------------------------------------------------------				/** SWFAddress change handler **/		public function onSWFAddressChange(event:SWFAddressEvent):void		{			trace("MediaRoom.onSWFAddressChange "+event.value);			addressID = event.value.substring(1);						var titleString:String = siteXML.title;			titleString += " | " + siteXML..media.(@id == addressID).@name			SWFAddress.setTitle(titleString);			var mediaFile:String = siteXML..media.(@id == addressID);			mediaWidth = int(siteXML..media.(@id == addressID).@width);			mediaHeight = int(siteXML..media.(@id == addressID).@height);			if (mediaFile != "")				loadMedia(mediaFile);		}				/** Create navigation **/		public function createNav():void		{			trace("MediaRoom.createNav");						// Set BasicButtonMenu properties			nav = new AccordionMenu();			nav.isVertical = true;			nav.spacing = int(siteXML.nav.spacing);			nav.bubbles = false;			nav.addEventListener(UIEvent.BUTTON_SELECT, onButtonSelect);			nav.addEventListener(UIEvent.DROPDOWN_SELECT, onSubNavButtonSelect);						// Create nav buttons			for each (var child:XML in siteXML.content.*) 			{				var navButton:Sprite = createNavButton(child.@name);				var buttonAlpha:Number = 1;				if (String(child.@dim) == "true")					buttonAlpha = .5;				nav.addButton(navButton, "", buttonAlpha);				if (child.localName()=="grouping")				{					var subnav:BasicButtonMenu = new BasicButtonMenu();					for each (var grandchild:XML in child.*)					{						var subnavButton:Sprite = createNavButton(grandchild.@name, "subnav");						if (String(grandchild.@dim) == "true")							buttonAlpha = .5;						subnav.addButton(subnavButton, "", buttonAlpha);					}					nav.addPanelMenu(subnav, nav.buttons.length - 1);				}			}						var navGraphicURL:String = String(siteXML.nav.graphic);			if (navGraphicURL != "")			{				var navGraphic:ImageDisplay = new ImageDisplay(String(siteXML.content.@path) + navGraphicURL);				navGraphic.addEventListener(Event.COMPLETE, onNavGraphicLoadComplete);			}		}				/** Creates and retruns a sprite for a single nav button instance **/		public function createNavButton(buttonText:String, tag:String = "nav"):Sprite		{			var btn:Sprite = new Sprite();			buttonText = "<"+tag+">"+buttonText+"</"+tag+">"			var tb:HTMLTextBlock = new HTMLTextBlock(buttonText, 													 0,													 textStyleSheet);			btn.addChild(tb);			return btn;		}				public function onNavGraphicLoadComplete(event:Event):void		{			trace("MediaRoom.onNavGraphicLoadComplete");			event.target.removeEventListener(Event.COMPLETE, onNavGraphicLoadComplete);			var selectGraphic:Sprite = Sprite(event.target)			nav.addButtonSelectGraphic(selectGraphic, int(siteXML.nav.graphic.@offsetx), int(siteXML.nav.graphic.@offsety));		}				/** Actions initiated when nav button is clicked **/		public function onButtonSelect(event:UIEvent):void		{			trace("MediaRoom.onButtonSelect "+nav.currButtonIndex);			if (siteXML.content.*[nav.currButtonIndex].localName() == "media")				SWFAddress.setValue(siteXML.content.*[nav.currButtonIndex].@id);						if (siteXML.content.*[nav.currButtonIndex].localName() == "grouping")			{				var panelHeight:int = nav.panels[nav.currButtonIndex].height;				if (nav.isExpanded)					panelHeight *= -1;				transitionFooter(panelHeight);			}		}				/** Actions initiated when nav button is clicked **/		public function onSubNavButtonSelect(event:UIEvent):void		{			trace("MediaRoom.onSubNavButtonSelect "+nav.currButtonIndex+"/"+event.value);			SWFAddress.setValue(siteXML.content.*[nav.currButtonIndex].media[event.value].@id);		}					//--------------------------------------------------------------------------    //    //  MEDIA LOADING    //    //--------------------------------------------------------------------------				/** Loads media 		*	@param url URL of media file(s) to load		**/		public function loadMedia(url:String, w:int = 0, h:int = 0):void		{			trace("MediaRoom.loadMedia: "+url);			SoundMixer.stopAll();			mediaTransitionComplete = false;			prevMedia = currMedia;			if (prevMedia)				transitionMediaOut(prevMedia);						var contentDisplay:Sprite = contentCreator.create(url);			contentDisplay.addEventListener(Event.COMPLETE, onMediaLoadComplete, false, 0, true);			contentDisplay.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);			contentDisplay.addEventListener(UIEvent.PLAYBACK_START, onVideoPlaybackStart, false, 0, true);			contentDisplay.addEventListener(UIEvent.PLAYBACK_FINISH, onVideoPlaybackFinish, false, 0, true);						if (contentDisplay is VideoDisplay) {				var video:VideoDisplay = contentDisplay as VideoDisplay;				video.player.enableFullScreen(false);			}						currMedia = new Sprite();			currMedia.addChild(contentDisplay);						if (!contentDisplay) 				trace("Error: Could not initialize content: "+url);			else				track("Content View", url);		}				/** Actions initiated after section load is complete **/		public function onMediaLoadComplete(event:Event):void		{			trace("MediaRoom.onMediaLoadComplete");			event.target.removeEventListener(Event.COMPLETE, onMediaLoadComplete);			event.target.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);			if (mediaWidth == 0)				mediaWidth = currMedia.width;			if (mediaHeight == 0)				mediaHeight = currMedia.height;						if (mediaWidth != currMedia.width || mediaHeight != currMedia.height)			{				var mediaMask:RectangleShape = new RectangleShape(mediaWidth, mediaHeight);				currMedia.addChild(mediaMask);				currMedia.getChildAt(0).mask = mediaMask;			}			resizeSWF();			transitionMediaIn(currMedia);		}			//--------------------------------------------------------------------------    //    //  EVENT HANDLING    //    //--------------------------------------------------------------------------				//----------------------------------  		//  STAGE RESIZE    	//----------------------------------				/** Stage resizing manager **/		public function onStageResize(event:Event = null):void		{			if (nav)			{				var navX:int = stage.stageWidth - nav.width - nav.y;				if (navX < mediaWidth + nav.y + 1)					navX = mediaWidth + nav.y + 1;				nav.x = navX;			}			if (snipe)			{				var snipeX:int = stage.stageWidth - snipe.width + int(siteXML.snipe.@offsetx);				if (snipeX < footer.container.width)					snipeX = footer.container.width;				snipe.x = snipeX;			}			if (footer)			{				footer.background.width = stage.stageWidth;				footer.background.height = stage.stageHeight - contentHeight;			}		}				/** Uses swffit.js to resize swfobject container div **/		public function resizeSWF():void		{			var navWidth:int = 0;			if (nav)				navWidth = navWidth;			var siteWidth:int = mediaWidth + navWidth;			var footerHeight:int = 60;			if (footer)				footerHeight = footer.container.y + footer.container.height;			var siteHeight:int = mediaHeight + footerHeight;			SWFFit.configure( { minWid: siteWidth, minHei: siteHeight } );		}				//----------------------------------  		//  TRACKING    	//----------------------------------				/** Initializes Google Analytics Event Tracking **/		public function initTracking():void		{			tracker = new GATracker(this, trackingCode, "AS3", false); 			tracker.trackPageview( "/"+siteXML.title);		}				/** Initializes Google Analytics Event Tracking **/		public function trackEventHandler(event:TrackEvent):void 		{			track(event.trackAction, event.trackLabel);		}				/** Send tracking call to Google Analytics **/		public function track(trackAction:String, trackLabel:String = "") :void		{			if (tracker) 			{				trace("TRACKING | "+siteXML.title+" action:"+trackAction+" label:"+trackLabel);				tracker.trackEvent(siteXML.title, trackAction, trackLabel);			}		}				public function onVideoPlaybackStart(event:UIEvent):void		{			track("VideoStart", addressID);		}				public function onVideoPlaybackFinish(event:UIEvent):void		{			track("VideoPlaybackFinish", addressID);		}				//----------------------------------  		//  ERRORS    	//----------------------------------				/** Error message handler **/		public function errorHandler(event:Event):void 		{			trace(event);		}	//--------------------------------------------------------------------------    //    //  TRANSITIONS    //    //--------------------------------------------------------------------------			/** Transition in animation for footer **/		public function transitionFooter(navHeightMod:int = 0):void		{			trace("MediaRoom.transitionFooter");			footer.visible = true;			var navAreaHeight:int = nav.height + int(siteXML.nav.margin) + int(siteXML.nav.spacing);			// adjust for if snipe rises above the footer			if (snipe)			{				if (snipe.y < 0)					navAreaHeight -= snipe.y;			}						navAreaHeight += navHeightMod;				contentHeight = (mediaHeight > navAreaHeight) ? mediaHeight : navAreaHeight;			if (contentHeight < minContentHeight)				contentHeight = minContentHeight;			TweenLite.to(footer, .25, {y:contentHeight, ease:Expo.easeInOut});			TweenLite.to(footer.background, .25, {height:stage.stageHeight - contentHeight, ease:Expo.easeInOut});		}				/** Transition in animation for nav **/		public function transitionNavIn():void		{			trace("MediaRoom.transitionNavIn");			nav.updateMasks();			nav.x = stage.stageWidth - nav.width - int(siteXML.nav.margin);			TweenLite.from(nav, .5, {x:nav.x + nav.width*2, alpha:0, delay:1.5, ease:Expo.easeOut, onComplete:transitionNavInComplete});			nav.y = int(siteXML.nav.margin);			addChild(nav);		}				/** Transition in animation for nav **/		public function transitionNavInComplete():void		{			trace("MediaRoom.transitionNavIn");			var mediaTitle:String = SWFAddress.getValue().substring(1);						trace("Number of Media: "+siteXML..media.length());			//siteXML..media.(@id == addressID).@name			if (mediaTitle == "")			{				nav.selectButton(0);				onButtonSelect(null);			}			else			{				var numMedia:int = siteXML..media.length();				for (var i:int = 0; i < numMedia; i++)				{					trace("Media Title: "+mediaTitle);					trace("siteXML..media[i].@id "+siteXML..media[i].@id);					if (mediaTitle == siteXML..media[i].@id)						nav.selectButton(i);				}			}		}				/** Transition in animation for content sections **/		public function transitionMediaIn(media:Sprite):void		{			trace("MediaRoom.transitionMediaIn");			addChildAt(media, 0);			if (footer)				transitionFooter();			TweenLite.from(media, 1, {alpha:0, x:-media.width, onComplete:transitionMediaInComplete, ease:Expo.easeInOut, delay:.25, onCompleteParams:[media]});		}				/** Transition in animation for content sections **/		public function transitionMediaInComplete(media:Sprite):void		{			trace("MediaRoom.transitionMediaInComplete");			mediaTransitionComplete = true;			if (footer)			{				if (!footer.visible)					transitionFooter();			}			onStageResize();		}				/** Transition out animation for content sections **/		public function transitionMediaOut(media:Sprite):void		{			trace("MediaRoom.transitionMediaOut");			TweenLite.to(media, .5, {x:-media.width, alpha:0, onComplete:transitionMediaOutComplete, ease:Expo.easeInOut, onCompleteParams:[media]});		}				/** Transition out animation for content sections **/		public function transitionMediaOutComplete(media:Sprite):void		{			trace("MediaRoom.transitionMediaOutComplete");			media.parent.removeChild(media);			media = null;		}	}}