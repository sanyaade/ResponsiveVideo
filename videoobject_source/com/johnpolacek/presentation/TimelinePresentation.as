﻿package com.johnpolacek.presentation{	import flash.display.MovieClip;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.ui.Mouse;	import flash.ui.Keyboard;	import flash.utils.Timer;    import flash.events.TimerEvent;	import flash.media.SoundMixer;	import com.johnpolacek.utils.TimelineUtils;	import com.johnpolacek.utils.DisplayUtils;	 /** * TimelinePresentation is used to create linear presentations animated on the timeline. * It replaces normal timeline behavior with custom behaviors.  *  * To create a timeline presentation, open a new flash doc and have the document class  * extend TimelinePresentation *  * Animate the presentation via the timeline. In the actions layer, instead of stop(); * keyframes, use stopTimeline(); - this is so the timeline gets stopped when playing in * reverse. * * Use the pauseTimeline(seconds:Number) method to pause the timeline. *  * For long presentations, separate different chapters into scenes, and use the navigation * controls to skip between chapters. *  * Presentations are meant to run locally, so streaming video is not recommended. * Embed videos so the presentation is entirely contained in a projector file. * * <b>Navigation:</b> * <ul> * 	<li>RIGHT ARROW: play forward * 	<li>LEFT ARROW: play in reverse * 	<li>SPACE BAR: toggle play/pause * 	<li>SHIFT + RIGHT ARROW: jump to next scene, pause * 	<li>SHIFT + LEFT ARROW: jump to start of scene or previous scene, pause * </ul> *  * @version  * <b>27 Mar 2010</b>  * @author John Polacek, john@johnpolacek.com */	 		public class TimelinePresentation extends MovieClip	{				/** Used to disable timeline navigation, for example to disable until a video finishes playback **/		public var timelineControlsEnabled:Boolean = true;		/** Used to keep track of the playback direction on the main timeline **/		public var isPlayingForward:Boolean = true;				private var timelineTimer:Timer;		private var pauseTimer:Timer;						public function TimelinePresentation()		{			stop();						// Add listeners			//			//this.addEventListener(MouseEvent.CLICK, clickHandler); 				// uncomment to make timeline playForward on click			//Mouse.hide; 															// uncomment to hide mouse			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);									// Create timer for controlling timeline			//			timelineTimer = new Timer(1000/stage.frameRate);			timelineTimer.addEventListener(TimerEvent.TIMER, timelineTimerHandler);			pauseTimer = new Timer(1000,1);			pauseTimer.addEventListener(TimerEvent.TIMER, pauseTimerHandler);		}		    //--------------------------------------------------------------------------    //    //  EVENT HANDLERS    //    //--------------------------------------------------------------------------				private function keyboardHandler(event:KeyboardEvent):void 		{			var currentSceneIndex:int = TimelineUtils.getSceneIndex(scenes, currentScene);						if (currentSceneIndex != -1) // if error, do nothing			{				if (event.shiftKey)				{					if (event.keyCode == Keyboard.RIGHT)  // SHIFT+RIGHT = Skip to next scene					{						if (currentSceneIndex != scenes.length-1) 						{							gotoScene(currentSceneIndex+1); // If at end, do nothing						}					}					if (event.keyCode == Keyboard.LEFT)  // SHIFT+LEFT = Rewind to start of scene or previous scene					{						if (currentFrame == 1) // If at first frame go to previous scene						{							if (currentSceneIndex != 0) 							{								gotoScene(currentSceneIndex-1);		// If not at start of movie go to previous scene							}						}						else	// otherwise go to start of current scene						{							gotoScene(currentSceneIndex);						}					}				}				else				{					if (timelineControlsEnabled)					{						if (event.keyCode == Keyboard.RIGHT) playForward(); 						if (event.keyCode == Keyboard.LEFT) playReverse();						if (event.keyCode == Keyboard.SPACE)						{							if (timelineTimer.running) 								stopTimeline();  // SPACE toggles play/pause							else 								playForward(); 						}					}				}			}		}				private function timelineTimerHandler(te:TimerEvent):void 		{			timelineControlsEnabled = true;			if (isPlayingForward)  				this.nextFrame();			else				this.prevFrame();		}				private function pauseTimerHandler(te:TimerEvent):void 		{			if (isPlayingForward)				playForward();			else				playReverse();		}		    //--------------------------------------------------------------------------    //    //  PUBLIC METHODS    //    //--------------------------------------------------------------------------		/** Go to and play the timeline from a given frame number * 		* @param frameNumber Frame number to navigate to in the timeline		*/		public function gotoAndPlayTimeline(frameNumber:int):void		{			gotoAndStop(frameNumber);			playForward();		}				/** Stops timeline */		public function gotoScene(sceneNumber:int):void		{			DisplayUtils.removeAllChildren(this);			SoundMixer.stopAll();			gotoAndStop(1, scenes[sceneNumber].name);			stopTimeline();		}				/** Stops timeline */		public function stopTimeline():void 		{			timelineTimer.stop();			stop();			timelineControlsEnabled = true;		}				/** Pauses timeline		* 		* @param seconds number of seconds the timeline is paused		*/		public function pauseTimeline(seconds:Number = 1):void		{			stopTimeline();			pauseTimer.delay = seconds*1000;			pauseTimer.start();		}				/** Plays timeline forward */		public function playForward():void 		{			isPlayingForward = true;			if (!timelineTimer.running) 				timelineTimer.start();		}				/** Plays timeline in reverse */		public function playReverse():void 		{			isPlayingForward = false;			if (!timelineTimer.running) 				timelineTimer.start();		}				/**		* Turns off controls and forces timeline to play forward until it gets stop(); command		* Useful for streaming audio, which won't play if tweening via a timer		*/		public function forcePlayTimeline():void		{			stopTimeline();			timelineControlsEnabled = false;			play();		}	}}