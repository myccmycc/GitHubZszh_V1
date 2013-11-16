package zszh_WorkSpace2D
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.managers.CursorManager;
	
	import zszh_Core.CommandManager;

	public class Room_2DCorner extends Object2D_Base
	{
		[Embed(source="../embeds/rooms/cursor_corner.png")]
		private var _cursorCorner:Class;
		private var _cursorSprite:Sprite;
		
		public  var _posInRoom:int;
		private var _postion:Point;
		
		private var _thisRoom:Object2D_Room;
		
		public function Room_2DCorner()
		{
			super();
			
			_cursorSprite=new Sprite();
			_cursorSprite.addChild(new _cursorCorner());
			addChild(_cursorSprite);
			_cursorSprite.visible=false;
			
			_postion=new Point;
			addEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
			addEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,CornerMouseDown);
			addEventListener(Event.ADDED,OnAdd);
		}
		
		private function OnAdd(event:Event):void
		{
			_thisRoom=(this.parent as Object2D_Room);
		}
		
		override public function Draw():void
		{
			
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			if(room_2d)
			{
				_postion.x=room_2d._vertexVec1[_posInRoom];
				_postion.y=-room_2d._vertexVec1[_posInRoom+1];
			}
			else 
			{
				_postion.x=0;
				_postion.y=0;
			}
			
			if(_selected)
			{
				graphics.clear();
				graphics.lineStyle(1,0x000000);
				graphics.beginFill(0xffffff,1);
				graphics.drawCircle(_postion.x,_postion.y,10);
				graphics.endFill();
			}
			else graphics.clear();
		}	
		
		//---------------corner mouse event OVER OUT---------------------------------------------
		private function CornerMouseOVER(e:MouseEvent):void
		{
			if(!_selected)
				return;
			ShowCursorCorner();
		}
		private function CornerMouseOut(e:MouseEvent):void
		{
			if(!_selected)
				return;
			HideCursorCorner();
		}
		
		private function ShowCursorCorner():void
		{
			CursorManager.hideCursor();
			
			_cursorSprite.visible=true;
			_cursorSprite.x=_postion.x-_cursorSprite.width/2;
			_cursorSprite.y=_postion.y-_cursorSprite.height/2;
		}
		
		private function HideCursorCorner():void
		{
			CursorManager.showCursor();
			_cursorSprite.visible=false;
		}
		
		//---------------corner mouse event DOWN UP MOVE---------------------------------------------
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		private var lastVectex:Vector.<Number>=new Vector.<Number>;
		
		private function CornerMouseDown(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			bStart=true;
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
			
			//保存上次的vextex数据
			lastVectex=new Vector.<Number>;
			 
			var len:int=_thisRoom._vertexVec1.length;
			for(var i:int=0;i<len;i++)
			{
				lastVectex[i]=_thisRoom._vertexVec1[i];
			}
			
			
			this.removeEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
			
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			}
			
			e.stopPropagation();
		}
		
		private function CornerMouseUp(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			bStart=false;
			HideCursorCorner();
			
			if(_thisRoom)
				CommandManager.Instance.MoveRoomVertex(_thisRoom,lastVectex,_thisRoom._vertexVec1);
			
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,CornerMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP,CornerMouseUp);
			}
			addEventListener(MouseEvent.MOUSE_OUT,CornerMouseOut);
			addEventListener(MouseEvent.MOUSE_OVER,CornerMouseOVER);
			
			_thisRoom.CheckVertexData();
		}
		private function CornerMouseMove(e:MouseEvent):void
		{
			if(!bStart)
				return;
			
			MoveCorner(_posInRoom);
			ShowCursorCorner();
			
			startPoint.x=this.stage.mouseX;
			startPoint.y=this.stage.mouseY;
			
		}
		
		private function MoveCorner(pos:int):void
		{
			if(_thisRoom==null)
				return;
			
			var VMouseMove:Point=new Point((int)(this.stage.mouseX-startPoint.x),int(-this.stage.mouseY+startPoint.y));
			
			var vectex:Vector.<Number>=new Vector.<Number>;
			for(var i:int=0;i<_thisRoom._vertexVec1.length;i++)
			{
				vectex.push(_thisRoom._vertexVec1[i]);
			}
			
			vectex[pos]+=VMouseMove.x;
			vectex[pos+1]+=VMouseMove.y;
			
			if(Object2D_Utility.SelfIntersection(vectex,pos))
				return;
			
			if(Object2D_Utility.SelfIntersection(vectex,(pos-2+vectex.length)%vectex.length))
				return;
			
			_thisRoom._vertexVec1[pos]+=VMouseMove.x;
			_thisRoom._vertexVec1[pos+1]+=VMouseMove.y;
			
			_thisRoom.Object2DUpdate();
		}
	}
}