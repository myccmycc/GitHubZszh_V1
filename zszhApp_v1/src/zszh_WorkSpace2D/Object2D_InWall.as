package zszh_WorkSpace2D
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	
	import zszh_Core.CommandManager;


	public class Object2D_InWall extends Object2D_Base
	{
		public  var _vertexVec1:Vector.<Number>;
				
		private  var _vertexVec2:Vector.<Number>;
		private  var _vertexVec3:Vector.<Number>;
		
		public  var _vertexVec:Vector.<Number>;


		public var _wallType:String;//0横,1竖着
		
		private var _lineColor:uint;
		private var _wallColor:uint;
		private var _wallColorSelected:uint;
		

		public function Object2D_InWall(type:String,vec:Vector.<Number>=null)
		{
			super();
			_vertexVec1=new Vector.<Number>();
			_vertexVec2=new Vector.<Number>();
			_vertexVec3=new Vector.<Number>();
			_vertexVec=new Vector.<Number>();
			
			if(vec!=null)
				_vertexVec1=vec;
			
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			if(type=="1" || type =="2")
				_wallType=type;
			else trace("ERROR:Wall_2D have wrong wall type "+ type );
			_selected=true;
			
			_lineColor=0xffffff;
			_wallColor=0x7c7e89;
			_wallColorSelected=0xff6666;
			
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
		}
		
		public function SetAllSelect(b:Boolean):void
		{
			for(var i:int=0;i<this.numChildren ;i++)
			{
				var obj:DisplayObject=getChildAt(i);
				if(obj is Object2D_InWallCorner)
					(obj as Object2D_InWallCorner).SetSelected(b);
			}
		}
		
		override public function SetSelected(b:Boolean):void
		{
			_selected=b;
			SetAllSelect(_selected);
			Object2DUpdate();
		}
		
		//--------------mouse event----------------------------------------
		private function MouseOver(e:MouseEvent):void
		{
			CursorManager.setCursor(FlexGlobals.topLevelApplication.imageCursor);
		}
		private function MouseOut(e:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}
		
		private var _oldPos:Point;
		private function MouseDown(e:MouseEvent):void
		{
			SetSelected(false);
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP,MouseUp);
			_oldPos=new Point(x,y);
			e.stopPropagation();
		}
		
		private function MouseUp(e:MouseEvent):void
		{
			stopDrag();
			if(_oldPos.x!=x || _oldPos.y!=y)
			{
				CommandManager.Instance.Move(this,_oldPos,new Point(x,y));
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,MouseUp);
			SetSelected(true);
			e.stopPropagation();
		}
		
		
		

		override public function Object2DUpdate():void
		{
			UpdateData();
			Draw();
		}
				
		private function OnCreation_Complete(e:FlexEvent):void
		{
			
			if(_wallType=="1")
			{
				_vertexVec1.push(0,0,100,0);
			}
			else if(_wallType=="2")
			{
				_vertexVec1.push(0,0,0,100);
			}
	
			UpdateData();

			
			//wall corners 
			for(var i:int=0;i<_vertexVec1.length;i+=2)
			{
				var wallCorner:Object2D_InWallCorner=new Object2D_InWallCorner();
				wallCorner._posInWall=i;
				addChild(wallCorner);
			}
			
			SetSelected(true);
			Draw();
		}
		
		// not fixed
		private function UpdateData():void
		{

				var P1:Point=new Point(_vertexVec1[0],_vertexVec1[1]);
				var P2:Point=new Point(_vertexVec1[2],_vertexVec1[3]);
			
				var distance:int=10;
				var A1:Number=(P2.y-P1.y);
				var B1:Number=(P1.x-P2.x);
				var C1:Number = P2.x*P1.y-P1.x*P2.y;
				
				var aabb:Number=Math.sqrt(A1*A1+B1*B1);
				var s:Number=distance*aabb;
				var C1_1:Number=C1+s;
				var C1_2:Number=C1-s;
				
				
				//Normal
				var A3:Number=B1;
				var B3:Number=-A1;
				var C3_1:Number = -A3*P1.x-B3*P1.y;
				var C3_2:Number = -A3*P2.x-B3*P2.y;
					
				var p1:Point=Object2D_Utility.Intersection(A1,B1,C1_1,A3,B3,C3_1);
				_vertexVec2[0]=p1.x;
				_vertexVec2[1]=p1.y;
				
				var p2:Point=Object2D_Utility.Intersection(A1,B1,C1_1,A3,B3,C3_2);
				_vertexVec2[2]=p2.x;
				_vertexVec2[3]=p2.y;
				
				var p3:Point=Object2D_Utility.Intersection(A1,B1,C1_2,A3,B3,C3_1);
				_vertexVec3[0]=p3.x;
				_vertexVec3[1]=p3.y;
				
				var p4:Point=Object2D_Utility.Intersection(A1,B1,C1_2,A3,B3,C3_2);
				_vertexVec3[2]=p4.x;
				_vertexVec3[3]=p4.y;

				
				_vertexVec[0]=_vertexVec2[0];
				_vertexVec[1]=_vertexVec2[1];
				_vertexVec[2]=_vertexVec2[2];
				_vertexVec[3]=_vertexVec2[3];
				_vertexVec[4]=_vertexVec3[2];
				_vertexVec[5]=_vertexVec3[3];
				_vertexVec[6]=_vertexVec3[0];
				_vertexVec[7]=_vertexVec3[1];
			 
		}
		
		override public function Draw():void
		{
			//wall
			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			if(_selected)
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			graphics.moveTo(_vertexVec2[0],_vertexVec2[1]);
			graphics.lineTo(_vertexVec2[2],_vertexVec2[3]);
			graphics.lineTo(_vertexVec3[2],_vertexVec3[3]);
			graphics.lineTo(_vertexVec3[0],_vertexVec3[1]);
			graphics.endFill();
			
		}
		
	}
}