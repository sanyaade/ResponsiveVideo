﻿package com.johnpolacek.application{	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.BitmapDataChannel;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import com.greensock.TweenLite;	import com.johnpolacek.events.UIEvent;	import com.johnpolacek.shapes.Line;	import com.johnpolacek.shapes.RectangleShape;	import com.johnpolacek.text.HTMLTextBlock;	import com.johnpolacek.text.BasicTextBlock;	import com.johnpolacek.ui.BasicButtonMenu;	import com.johnpolacek.ui.DropDownButtonMenu;	 /** * Class for BriefingRoom nav menu *  * @version 13 Apr 2010 * @author John Polacek, john@johnpolacek.com */	 		public class BriefingRoomNav extends Sprite	{					// display objects		public var menu:DropDownButtonMenu;				// formatting		private var format:BriefingRoomFormat;						// button titles		private var titles = []; 				/** 		* @param t Array of strings that are used for the nav button text.		* @param f BriefingRoomFormat object. Default null (Default formatting is used)		**/		public function BriefingRoomNav(t:Array, f:BriefingRoomFormat = null)		{			if (f)				format = f;			else				format = new BriefingRoomFormat();			titles = t;			menu = new DropDownButtonMenu;			menu.buttonAlpha = .6;			menu.isVertical = false;			menu.spacing = 10;			addChild(menu);			for each (var sectionTitle:String in titles) 			{				var navButton:Sprite = createNavButton(sectionTitle);				menu.addButton(navButton);			}			TweenLite.from(menu, 2, {alpha:0});			menu.x = format.navSpacing;		}			//--------------------------------------------------------------------------    //    //  Object Creation    //    //--------------------------------------------------------------------------				private function createNavButton(buttonText:String):Sprite		{			var btn:Sprite = new Sprite();			var tb:BasicTextBlock = new BasicTextBlock(buttonText, 0, format.navTextFormat);			btn.addChild(tb);				return btn;		}				private function createDropDownButton(buttonText:String):Sprite		{			var btn:Sprite = new Sprite();			var tb:BasicTextBlock = new BasicTextBlock(buttonText, 0, format.dropdownTextFormat);			btn.addChild(tb);				return btn;		}				public function addDropDown(t:Array, i:int):void		{			var dropDown:BasicButtonMenu = new BasicButtonMenu(.5);			dropDown.isVertical = true;			for each (var subsectionTitle:String in t) 			{				var navButton:Sprite = createDropDownButton(subsectionTitle);				dropDown.addButton(navButton);			}			// align right			for (var j:int = 0; j < dropDown.numChildren; j++)			{				dropDown.getChildAt(j).x = dropDown.width - dropDown.getChildAt(j).width;			}			dropDown.addBackground(format.dropdownColor, format.dropdownAlpha);			dropDown.x =  menu.buttons[i].width - dropDown.width;			menu.addDropDownMenu(dropDown, i);		}	}}