package zszh_WorkSpace2D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	
	public class Object2D_InWallCorner extends Object2D_Base
	{

		private var _thisWall:Object2D_InWall;
		public  var _posInWall:int;
		
		public function Object2D_InWallCorner()
		{
			super();
			addEventListener(MouseEvent.MOUSE_OVER,MouseOVER);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			addEventListener(Event.ADDED,OnAdd);
		}
		
		private function OnAdd(event:Event):void
		{
			_thisWall=(this.parent as Object2D_InWall);
		}


		override public function  Object2DUpdate():void
		{
			Draw();
		}
		override public function Draw():void
		{
			
			graphics.clear();
			if(!_selected)
				return;
			graphics.lineStyle(1,0x000000);
			graphics.beginFill(0xffffff,1);
			graphics.drawCircle(_thisWall._vertexVec1[_posInWall],_thisWall._vertexVec1[_posInWall+1],10);
			graphics.endFill();
		}
		
		//---------------corner mouse event---------------------------------------------
		private function MouseOVER(e:MouseEvent):void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		private function MouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}
		
		
		
		//---------------corner mouse event---------------------------------------------
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		private var lastVectex:Vector.<Number>=new Vector.<Number>;
 
		
		private function MouseDown(e:MouseEvent):void
		{
			bStart=true;
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
			
			lastVectex=new Vector.<Number>;
			
			var len:int=_thisWall._vertexVec1.length;
			for(var i:int=0;i<len;i++)
			{
				lastVectex[i]=_thisWall._vertexVec1[i];
			}
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
			e.stopPropagation();
		}
		
		private function CornerMouseUp(e:MouseEvent):void
		{
			bStart=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			CursorManager.removeAllCursors();
		}
		private function CornerMouseMove(e:MouseEvent):void
		{
			if(!bStart)
				return;
			if(MoveCorner(_posInWall))
			{
				startPoint.x=this.stage.mouseX;
				startPoint.y=this.stage.mouseY;
			}
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		
		private function MoveCorner(i:int):Boolean
		{
			if(!_thisWall)
			    _thisWall=(this.parent as Object2D_InWall);
			
			var VMouseMove:Point=new Point((int)(this.stage.mouseX-startPoint.x),int(-this.stage.mouseY+startPoint.y));
			trace("VMouseMove:"+VMouseMove);
			
			var vetexLen:int=_thisWall._vertexVec1.length;
			
			var P1:Point=new Point(_thisWall._vertexVec1[i]+VMouseMove.x,_thisWall._vertexVec1[i+1]-VMouseMove.y);
			var P2:Point=new Point(_thisWall._vertexVec1[(i+2)%vetexLen],_thisWall._vertexVec1[(i+3)%vetexLen]);
			
			if(_thisWall._wallType=="1")
			{
				var p2p1:Point=new Point(P2.y-P1.y,P2.x-P1.x);
				var dir:Point=new Point(0,100);
				
				
				var d:Number=p2p1.x*dir.x+p2p1.y*dir.y;
				var d1:Number=Math.sqrt(p2p1.x*p2p1.x+p2p1.y*p2p1.y) * Math.sqrt(dir.x*dir.x+dir.y*dir.y);
				var arg:Number= Math.acos(d/d1);
				var ang:Number=arg*180/Math.PI;
				
				if(ang>175 || ang<5)
				{
					_thisWall._vertexVec1[i+1]=_thisWall._vertexVec1[(i+3)%vetexLen];
					_thisWall._vertexVec1[i]+=VMouseMove.x;
					startPoint.x=this.stage.mouseX;
					_thisWall.Object2DUpdate();
					Object2DUpdate();
					return false;
				}
			}
			else if(_thisWall._wallType=="2")
			{
				p2p1=new Point(P2.y-P1.y,P2.x-P1.x);
				dir=new Point(100,0);
				
				
				d=p2p1.x*dir.x+p2p1.y*dir.y;
				d1=Math.sqrt(p2p1.x*p2p1.x+p2p1.y*p2p1.y) * Math.sqrt(dir.x*dir.x+dir.y*dir.y);
				arg= Math.acos(d/d1);
				ang=arg*180/Math.PI;
				
				if(ang>175 || ang<5)
				{
					_thisWall._vertexVec1[i]=_thisWall._vertexVec1[(i+2)%vetexLen];
					_thisWall._vertexVec1[i+1]-=VMouseMove.y;
					startPoint.y=this.stage.mouseY;
					_thisWall.Object2DUpdate();
					Object2DUpdate();
					return false;
				}
			}
			
			_thisWall._vertexVec1[i]+=VMouseMove.x;
			_thisWall._vertexVec1[i+1]-=VMouseMove.y
				
			_thisWall.Object2DUpdate();
			Object2DUpdate();
			return true;
			
		}
	}
}