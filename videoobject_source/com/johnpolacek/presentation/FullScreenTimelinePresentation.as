﻿package com.johnpolacek.presentation{	import flash.ui.Mouse;	import flash.media.SoundMixer;	import com.johnpolacek.presentation.TimelinePresentation;	import com.johnpolacek.utils.PresentationUtils;	import com.johnpolacek.media.VideoStreamPlayer;		public class FullScreenTimelinePresentation extends TimelinePresentation	{						public function FullScreenTimelinePresentation()		{			PresentationUtils.goFullScreen(stage);		}			}}