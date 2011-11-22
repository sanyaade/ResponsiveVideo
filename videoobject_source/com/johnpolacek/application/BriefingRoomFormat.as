﻿package com.johnpolacek.application {			 /** * The BriefingRoomFormat class represents formatting information for the BriefingRoom application class.  *  *  * Properties are set by xml data that is passed to the BriefingRoomFormat constructor. * Properties not defined in the xml file will retain their default values. *  * @version 13 Apr 2010 * @author John Polacek, john@johnpolacek.com */	 		import com.johnpolacek.components.LightboxFormat;	import flash.text.Font;	import flash.text.StyleSheet;	import flash.text.TextFormat;		public class BriefingRoomFormat {				/** 		* The url of the image or hexadecimal value of the color of the background		* Default: "0xFFFFFF"	**/		public var backgroundColor:uint = 0xFFFFFF;		/** 		* Width of BriefingRoom		* Default: 960	**/		public var roomWidth:int = 960;		/** 		* Height of BriefingRoom		* Default: 540	**/		public var roomHeight:int = 560;		/** 		* Sets the color of divider lines.		* Default:	0x000000 **/		public var lineColor:uint = 0xFFFFFF;		/** 		* The contentTextFormat property is a TextFormat object that is applied to all default content text.		* Default:	Default TextFormat object **/		public var contentTextFormat:TextFormat;		/** 		* The lightboxFormat property is a lightboxFormat object that is applied to the lightbox.		* Default:	Default LightboxFormat object **/		public var lightboxFormat:LightboxFormat;		/** 		* Sets the background color of the sections.		* Default:	0xFFFFFF **/		public var sectionColor:uint = 0xFFFFFF;		/** 		* Array containing filepaths to all runtime fonts (e.g. "fonts/ArialBlack.swf") 		* Default: [] (No runtime fonts, all text rendered as Times New Roman) **/		public var fonts:Array = [];		/** 		* StyleSheet that is applied to all html-formatted text		* Default: null (No styling) **/		public var textStyleSheet:StyleSheet = null;		/** 		* Object that contains formatting for the footer		* Default: {} (No footer)**/		public var footer = {};		/** 		* Object that contains formatting for the scrollbar		* Default: {} (Default format) **/		public var scrollbar = {};		/** 		* Object that contains formatting for the header		* Default: {} (Default format) **/		public var header = {};		/** 		* The navTextFormat property is a TextFormat object that is applied to the nav button TextFields.		* Default:	Default TextFormat object **/		public var navTextFormat:TextFormat;		/** 		* The dropdownTextFormat property is a TextFormat object that is applied to the nav dropdown button TextFields.		* Default:	Default TextFormat object **/		public var dropdownTextFormat:TextFormat;		/** 		* The navSpacing property determines the spacing between nav button TextFields.		* Default:	Default 20 pixels **/		public var navSpacing:int = 20;		/** 		* The dropdownColor property determines the color of the dropdown background rectangle		* Default:	.25 **/		public var dropdownColor:uint = 0x000000;		/** 		* The dropdownAlpha property determines the alpha of the dropdown background rectangle		* Default: .25 **/		public var dropdownAlpha:Number = .25;		/** 		* The enableFullScreenVideo property determines if the full screen button on the video player is visible		* Default: true **/		public var enableFullScreenVideo:Boolean = true;		/** 		* The videoPoster string can contain a file path to a poster image that will appear on all full screen videos (eg. a play button)		* Default: null (no poster) **/		public var videoPoster:String;						/** 		* @param xml XML containing formatting properties. Default null (default formatting is used)		**/		public function BriefingRoomFormat(xml:XML = null) 		{			if (xml==null)				xml = new XML();							if (int(xml.pages.width) != 0)				roomWidth = int(xml.pages.width) + int(xml.pages.margin)*2;							if (int(xml.height) != 0)				roomHeight = int(xml.pages.height) + int(xml.footer.height) + int(xml.header.height);								if (String(xml.background)!="") 				backgroundColor = uint(xml.background);							if (String(xml.lines)!="") 				lineColor = uint(xml.lines);					//----------------------------------  		//  fonts    	//----------------------------------			var fontsPath:String = (xml.fonts.@path);			for each (var fontURL:String in xml.fonts..font) 			{				fonts.push(fontsPath+fontURL+".swf");			}				//----------------------------------  		//  header    	//----------------------------------					// set default values			header = { height:30 };						if (int(xml.header.height)!=0) 				header.height = int(xml.header.height);				header.topmargin = int(xml.header.margin.top);				header.sidemargin = int(xml.header.margin.sides);					//----------------------------------  		//  scrollbar    	//----------------------------------					// set default values			scrollbar = { scrubColor:0x666666, scrubAlpha:1, trackColor:0x000000, trackAlpha:.5, height:10 };						// override defaults with settings from xml			if (String(xml.scrollbar.scrub.color)!="") 				scrollbar.scrubColor = uint(xml.scrollbar.scrub.color);							if (String(xml.scrollbar.scrub.alpha)!="") 				scrollbar.scrubAlpha = Number(xml.scrollbar.scrub.alpha);							if (String(xml.scrollbar.track.color)!="") 				scrollbar.trackColor = uint(xml.scrollbar.track.color);							if (String(xml.scrollbar.track.alpha)!="") 				scrollbar.trackAlpha = Number(xml.scrollbar.track.alpha);								if (int(xml.scrollbar.height)!=0) 				scrollbar.height = int(xml.scrollbar.height);										//----------------------------------  		//  content    	//----------------------------------							contentTextFormat = new TextFormat();						if (String(xml.content.text.body.size)!="") 				contentTextFormat.size = int(xml.content.text.body.size);							if (String(xml.content.text.body.font)!="") 				contentTextFormat.font = xml.content.text.body.font;						contentTextFormat.leading = int(xml.content.text.body.leading);			contentTextFormat.color = uint(xml.content.text.body.color);						//----------------------------------  		//  lightbox    	//----------------------------------							lightboxFormat = new LightboxFormat();						if (String(xml.lightbox.overlay.color)!="") 				lightboxFormat.backgroundColor = uint(xml.lightbox.overlay.color);							if (String(xml.lightbox.overlay.alpha)!="") 				lightboxFormat.backgroundAlpha = Number(xml.lightbox.overlay.alpha);							if (String(xml.lightbox.background.color)!="") 				lightboxFormat.contentBackgroundColor = uint(xml.lightbox.background.color);							if (String(xml.lightbox.background.dropshadow)!="") 				lightboxFormat.dropShadowAlpha = Number(xml.lightbox.background.dropshadow);							if (String(xml.lightbox.buttons.color)!="") 				lightboxFormat.buttonColor = uint(xml.lightbox.buttons.color);						lightboxFormat.titleTextFormat = new TextFormat(null,18,0x000000);			if (String(xml.lightbox.text.title.font)!="") 				lightboxFormat.titleTextFormat.font = xml.lightbox.text.title.font;							if (String(xml.lightbox.text.title.size)!="") 				lightboxFormat.titleTextFormat.size = xml.lightbox.text.title.size;							if (String(xml.lightbox.text.title.color)!="") 				lightboxFormat.titleTextFormat.color = xml.lightbox.text.title.color;					lightboxFormat.subtitleTextFormat = new TextFormat(null, 12, 0x000000);			if (String(xml.lightbox.text.subtitle.font)!="") 				lightboxFormat.subtitleTextFormat.font = xml.lightbox.text.subtitle.font;							if (String(xml.lightbox.text.subtitle.size)!="") 				lightboxFormat.subtitleTextFormat.size = xml.lightbox.text.subtitle.size;							if (String(xml.lightbox.text.subtitle.color)!="") 				lightboxFormat.subtitleTextFormat.color = xml.lightbox.text.subtitle.color;							lightboxFormat.noteTextFormat = new TextFormat(null, 10, 0x333333);			if (String(xml.lightbox.text.note.font)!="") 				lightboxFormat.noteTextFormat.font = xml.lightbox.text.note.font;							if (String(xml.lightbox.text.note.size)!="") 				lightboxFormat.noteTextFormat.size = xml.lightbox.text.note.size;							lightboxFormat.navTextFormat = new TextFormat(null, 10, 0x666666);			if (String(xml.lightbox.text.nav.font)!="") 				lightboxFormat.navTextFormat.font = xml.lightbox.text.nav.font;							if (String(xml.lightbox.text.nav.size)!="") 				lightboxFormat.navTextFormat.size = xml.lightbox.text.nav.size;							if (String(xml.lightbox.text.nav.color)!="") 				lightboxFormat.navTextFormat.color = xml.lightbox.text.nav.color;							lightboxFormat.audioTitleTextFormat = new TextFormat(null,14,0xFFFFFF);			if (String(xml.lightbox.text.audiotitle.font)!="") 				lightboxFormat.audioTitleTextFormat.font = xml.lightbox.text.audiotitle.font;							if (String(xml.lightbox.text.audiotitle.size)!="") 				lightboxFormat.audioTitleTextFormat.size = xml.lightbox.text.audiotitle.size;							if (String(xml.lightbox.text.audiotitle.color)!="") 				lightboxFormat.audioTitleTextFormat.color = xml.lightbox.text.audiotitle.color;								lightboxFormat.audioSubtitleTextFormat = new TextFormat(null, 12, 0xAAAAAA);			if (String(xml.lightbox.text.audiosubtitle.font)!="") 				lightboxFormat.audioSubtitleTextFormat.font = xml.lightbox.text.audiosubtitle.font;							if (String(xml.lightbox.text.audiosubtitle.size)!="") 				lightboxFormat.audioSubtitleTextFormat.size = xml.lightbox.text.audiosubtitle.size;							if (String(xml.lightbox.text.audiosubtitle.color)!="") 				lightboxFormat.audioSubtitleTextFormat.color = xml.lightbox.text.audiosubtitle.color;							//----------------------------------  		//  video    	//----------------------------------					if (String(xml.video.fullscreen) == "false") {				enableFullScreenVideo = false;				lightboxFormat.videoFullScreen = false;			}						if (String(xml.video.poster)) {				videoPoster = String(xml.video.poster);			}				//----------------------------------  		//  nav    	//----------------------------------							navTextFormat = new TextFormat();							if (String(xml.header.buttons.size)!="") 				navTextFormat.size = int(xml.header.buttons.size);							if (String(xml.header.buttons.font)!="") 				navTextFormat.font = xml.header.buttons.font;						navTextFormat.color = uint(xml.header.buttons.color);						if (String(xml.header.buttons.spacing)!="") 				navSpacing = int(xml.header.buttons.spacing);							dropdownTextFormat = new TextFormat();							if (String(xml.header.dropdown.size)!="") 				dropdownTextFormat.size = int(xml.header.dropdown.size);							if (String(xml.header.dropdown.font)!="") 				dropdownTextFormat.font = xml.header.dropdown.font;						dropdownTextFormat.color = uint(xml.header.dropdown.color);						if (String(xml.header.dropdown.background.color)!="") 				dropdownColor = uint(xml.header.dropdown.background.color);						if (String(xml.header.dropdown.background.alpha)!="") 				dropdownAlpha = Number(xml.header.dropdown.background.alpha);						}		}}