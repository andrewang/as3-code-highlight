package net.fproject.as3syntaxhighlight
{
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.utils.Timer;
	
	import mx.controls.TextArea;
	import mx.controls.textClasses.TextRange;
	import mx.events.FlexEvent;
	
	public class AS3CodeViewer extends TextArea
	{
		private var cssString:String =".spl {font-family:sandboxcode;color: #4f94cd;} .str { font-family:sandboxcode; color: #880000; } .kwd { font-family:sandboxcode; color: #000088; } .com { font-family:sandboxcode; color: #008800; } .typ { font-family:sandboxcode; color: #0068CF; } .lit { font-family:sandboxcode; color: #006666; } .pun { font-family:sandboxcode; color: #666600; } .pln { font-family:sandboxcode; color: #222222; } .tag { font-family:sandboxcode; color: #000088; } .atn { font-family:sandboxcode; color: #660066; } .atv { font-family:sandboxcode; color: #880000; } .dec { font-family:sandboxcode; color: #660066; } ";
		private var codeStyle:StyleSheet;
		private var codePrettyPrint:CodePrettyPrint;
		private var codeTimer:Timer;
		
		public function AS3CodeViewer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(e:FlexEvent):void
		{
			if ( !codeTimer )
			{
				codeTimer = new Timer(200,1);
				codeTimer.addEventListener(TimerEvent.TIMER, doPrettyPrint);
				
			}	
			
			if ( codeTimer.running )
			{
				codeTimer.stop();
			}
			codeTimer.reset();
			// wait for some time to see if we need to highlight or not
			codeTimer.start();
		}
		
		private function doPrettyPrint(event:TimerEvent):void
		{
			if ( !codeStyle )
			{
				codeStyle = new StyleSheet();
				codePrettyPrint = new CodePrettyPrint();
				codeStyle.parseCSS(cssString);
			}
			
			codePrettyPrint.prettyPrintOne(this.text, null, false);
			processFormattedCode(0, this.length);
			//trace(res);			
		}
		
		private function processFormattedCode(startIdx:int, endIdx:int, optIdx:int=0):void
		{			
			var srclen:int = endIdx - startIdx;
			var arr:Array = codePrettyPrint.mainDecorations;
			if ( arr == null || srclen < 1 ) 
			{
				return;
			}
			
			var len:int = arr.length;
			var firstNode:Boolean = false;
			var tr:TextRange;
			var thecolor:Object;
			var firstIndex:int = 0;
			for ( var i:int = optIdx; i < len; i+=2 )
			{
				/* find first node */
				if ( arr[i] == 0 )
				{					
					continue;
				}
				else if ( firstNode == false )
				{
					firstNode = true;
					firstIndex = i;
					
				} 
				if ( i - 2 > 0 )
				{
					tr = new TextRange(this, false, arr[i-2] + startIdx, arr[i] + startIdx);
					thecolor = codeStyle.getStyle("." + arr[i-1]).color;
					tr.color = thecolor;
				}
				
			}
			if ( i > 0 )
			{
				i -= 2;
				if ( arr[i] + startIdx < endIdx )
				{
					tr = new TextRange(this, false, arr[i] + startIdx, endIdx);
					thecolor = codeStyle.getStyle("." + arr[i+1]).color;
					tr.color = thecolor;
				}
			}			
			
		}
		
	}
}