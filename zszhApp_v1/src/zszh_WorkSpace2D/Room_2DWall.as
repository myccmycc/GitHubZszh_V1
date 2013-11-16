package zszh_WorkSpace2D
{

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	import zszh_Core.CommandManager;
	
	import zszh_WorkSpace2D.PopupMenu_Room2D_Wall;
	
	public class Room_2DWall extends Object2D_Base
	{
		private var _popupWindowMenu:PopupMenu_Room2D_Wall;
		private var _lineColor:uint;
		private var _wallColor:uint;
		private var _wallColorSelected:uint;
		
		private var _bHaveHole:Boolean;
		public  var _wallVertex1:Vector.<Number>;
		private var _wallPos:Vector.<Number>;
		
		public   var _postionInRoom:int;
		public   var _rotation:Number;
		private  var _thisRoom:Object2D_Room;
		
		[Bindable]
		[Embed(source="../embeds/rooms/cursor_wall.png")]
		private var _cursorWall:Class;
		private var _cursorSprite:Sprite;
		
		private var _txtDis :TextField;
		
		public function Room_2DWall()
		{
			super();
		
			_bHaveHole=false;
			_lineColor=0xffffff;
			_wallColor=0x7c7e89;
			_wallColorSelected=0xff6666;
			_wallPos=new Vector.<Number>;
			_wallVertex1=new Vector.<Number>;
			
			_cursorSprite=new Sprite();
			var img:Bitmap=new _cursorWall();
			_cursorSprite.addChild(img);
			img.x=-img.width/2;
			img.y=-img.height/2;
			addChild(_cursorSprite);
			_cursorSprite.visible=false;
			
			//text
			_txtDis= new TextField();
			_txtDis.autoSize = "center";
			_txtDis.text = "";
			var fmt :TextFormat = new TextFormat();
			fmt.size = 18;
			_txtDis.setTextFormat(fmt);
			addChild(_txtDis);
			
			addEventListener(Event.ADDED,OnAdd);
			addEventListener(MouseEvent.RIGHT_CLICK,RightMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,LeftMouseDown);
			
		}
		
		private function OnAdd(event:Event):void
		{
			if(parent==null)
				trace("error: Room_2DWall not in room! ")
			_thisRoom=(parent as Object2D_Room);
		}
		override public function Draw():void
		{
			var room_2d:Object2D_Room=this.parent as Object2D_Room;
			var len:int=room_2d._vertexVec1.length;
			
			_wallPos=new Vector.<Number>;
			_wallVertex1=new Vector.<Number>;
			
			_wallVertex1[0]=room_2d._vertexVec1[(_postionInRoom+2)%len];
			_wallVertex1[1]=room_2d._vertexVec1[(_postionInRoom+3)%len];
			_wallVertex1[2]=room_2d._vertexVec1[(_postionInRoom+4)%len];
			_wallVertex1[3]=room_2d._vertexVec1[(_postionInRoom+5)%len];
			
			_wallPos[0]=room_2d._vertexVec2[_postionInRoom];
			_wallPos[1]=room_2d._vertexVec2[_postionInRoom+1];
			_wallPos[2]=room_2d._vertexVec2[(_postionInRoom+2)%len];
			_wallPos[3]=room_2d._vertexVec2[(_postionInRoom+3)%len];
			_wallPos[4]=room_2d._vertexVec3[_postionInRoom];
			_wallPos[5]=room_2d._vertexVec3[_postionInRoom+1];
			_wallPos[6]=room_2d._vertexVec3[(_postionInRoom+2)%len];
			_wallPos[7]=room_2d._vertexVec3[(_postionInRoom+3)%len];
			
			_txtDis.text="";
			
			
			//compute _txtDis position
			var P1:Point=new Point( _wallVertex1[0] , -_wallVertex1[1] );
			var P2:Point=new Point( _wallVertex1[2] , -_wallVertex1[3] );
			
			if(WorkSpace2DContainer._gBShowScale && ( P1.x!=P2.x || P1.y!=P2.y ))
			{
				var dis:int=Math.sqrt( (_wallVertex1[0]-_wallVertex1[2])*(_wallVertex1[0]-_wallVertex1[2])+  ( _wallVertex1[1] - _wallVertex1[3])*( _wallVertex1[1] - _wallVertex1[3]));
				_txtDis.text = String(dis);
			
				//2 P1P2 直线方程  Ax+By+c=0的表达式
				var A1:Number=(P2.y-P1.y);
				var B1:Number=(P1.x-P2.x);
				var C1:Number = P2.x*P1.y-P1.x*P2.y;
			
				//Normal1
				var NA1:Number=B1;
				var NB1:Number=-A1;
				var NC1:Number = -NA1* P1 .x-NB1* P1 .y;
			
				//Normal2
				var NA2:Number=B1;
				var NB2:Number=-A1;
				var NC2:Number = -NA2* P2 .x-NB2* P2 .y;
			
				//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
				var aabb:Number=Math.sqrt(A1*A1+B1*B1);			
				var s2:Number=-40*aabb;
				var C1_1:Number=C1+s2;
			
				//求P1P2平移线 和P2P3平移线 交点
				p1=Object2D_Utility.Intersection(A1,B1,C1_1, NA1 , NB1 , NC1 );
				p2=Object2D_Utility.Intersection(A1,B1,C1_1, NA2 , NB2 , NC2 );
				_txtDis.x= p1.x+(p2.x-p1.x)/2;
				_txtDis.y= p1.y+(p2.y-p1.y)/2;
			}
			

			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			
			if(_selected)
				graphics.beginFill(_wallColorSelected,0.8);
			else
				graphics.beginFill(_wallColor,0.8);
			
			graphics.moveTo(_wallPos[0],-_wallPos[1]);
			graphics.lineTo(_wallPos[2],-_wallPos[3]);
			graphics.lineTo(_wallPos[6],-_wallPos[7]);
			graphics.lineTo(_wallPos[4],-_wallPos[5]);
			
			if(WorkSpace2DContainer._gBShowScale)
			{
				//text line
				graphics.moveTo(P1.x,P1.y);
				graphics.lineTo( p1.x,p1.y );
			
				graphics.moveTo(P2.x,P2.y);
				graphics.lineTo( p2.x,p2.y );
			
				graphics. moveTo(P1.x+ (p1.x-P1.x)/2,P1.y+ (p1.y-P1.y)/2 );
				graphics.lineTo(P2.x+ (p2.x-P2.x)/2,P2.y+ (p2.y-P2.y)/2 )
			}
			
			graphics.endFill();
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
			
			var p1:Point=new Point(_wallPos[2]-_wallPos[0],_wallPos[3]-_wallPos[1]);
			var p2:Point=new Point(1,0);
			
			_rotation=Object2D_Utility.GetAngle(p1,p2);
			
			for(var i:int=0;i<numChildren;i++)
			{
				if(getChildAt(i) is Object2D_Base)
					(getChildAt(i) as Object2D_Base).Draw();
			}
		}

		//--------popup menu function------------------------------------
		
		private function OnSplitWall(e:Event):void
		{
			trace("OnSplitWall");
			
			var vecLen:int=_thisRoom._vertexVec1.length;
			var pos:int=_postionInRoom;
			var P0:Point=new Point(_thisRoom._vertexVec1[(pos+2)%vecLen],_thisRoom._vertexVec1[(pos+3)%vecLen]);
			var P1:Point=new Point(_thisRoom._vertexVec1[(pos+4)%vecLen],_thisRoom._vertexVec1[(pos+5)%vecLen]);
			
			if(P0.x==P1.x&&P0.y==P1.y)
				return;
			
			var PMid:Point=new Point((P1.x-P0.x)/2+P0.x,(P1.y-P0.y)/2+P0.y);
			
			var newVectex:Vector.<Number>=new Vector.<Number>;
			for(var i:int=0;i<vecLen;i++)
			{
				if(i==(pos+4)%vecLen)
				{
					newVectex.push(PMid.x);
					newVectex.push(PMid.y);
					newVectex.push(PMid.x);
					newVectex.push(PMid.y)
				}
				
				newVectex.push(_thisRoom._vertexVec1[i]);
			}
			
			CommandManager.Instance.ChangeRoomVertex(_thisRoom,_thisRoom._vertexVec1,newVectex);
			_thisRoom._bSplit=true;
		}
		
		private function OnHoleWall(e:Event):void
		{
			trace("OnHoleWall");
			_bHaveHole=true;
		}
		
		private function OnDeleteWall(e:Event):void
		{
			trace("OnDeleteWall");
			this.visible=false;
		}
		
		
		
		//----------------mouse event OVER OUT ---------------------------------------
		
		private function MouseOver(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			ShowCursorCorner(new Point(this.mouseX,this.mouseY),_rotation);
			e.stopPropagation();
		}
		private function MouseOut(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			HideCursorCorner();
			e.stopPropagation();
		}
		
		private function ShowCursorCorner(postion:Point,rotation:Number):void
		{
			CursorManager.hideCursor();
			
			_cursorSprite.rotation=rotation+90;
			_cursorSprite.visible=true;
			_cursorSprite.x=postion.x;
			_cursorSprite.y=postion.y;
		}
		
		private function HideCursorCorner():void
		{
			CursorManager.showCursor();
			_cursorSprite.visible=false;
		}
		
		//----------------mouse event RIGHT MOUSE CLICK ---------------------------------------
		private function RightMouseClick(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
			_popupWindowMenu=new PopupMenu_Room2D_Wall();
			_popupWindowMenu.addEventListener(PopupMenu_Room2D_Wall.DELETE_WALL,OnDeleteWall,false,0,true);
			_popupWindowMenu.addEventListener(PopupMenu_Room2D_Wall.SPLIT_WALL,OnSplitWall,false,0,true);
			_popupWindowMenu.addEventListener(PopupMenu_Room2D_Wall.HOLE_WALL,OnHoleWall,false,0,true);
			PopUpManager.addPopUp(_popupWindowMenu,this,false);
		
			var pt:Point = new Point(e.localX, e.localY);
			pt = e.target.localToGlobal(pt);
			_popupWindowMenu.move(pt.x,pt.y);
			e.stopPropagation();
			
		}
		
	
		//----------------mouse event DOWN UP MOVE ---------------------------------------
		private var lastMousePoint:Point=new Point;
		private var bLeftMouseDown:Boolean=false;
		private var lastVectex:Vector.<Number>=new Vector.<Number>;
		private function LeftMouseDown(e:MouseEvent):void
		{
			trace("wall in room:"+_postionInRoom);
			if(!_selected)
				return;
		  
			bLeftMouseDown=true;
			lastMousePoint.x=this.mouseX;
			lastMousePoint.y=this.mouseY;
			
			lastVectex=new Vector.<Number>;
			
			var len:int=_thisRoom._vertexVec1.length;
			for(var i:int=0;i<len;i++)
			{
				lastVectex[i]=_thisRoom._vertexVec1[i];
			}
			
			
			ShowCursorCorner(new Point(mouseX,mouseY),_rotation);
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP,LeftMouseUp);
			}
			e.stopPropagation();
		}
		
		private function LeftMouseUp(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			if(lastVectex.length!=_thisRoom._vertexVec1.length)
				trace("Error: Wall LeftMouseUp lastVectex.length!=_thisRoom._vertexVec1.length ,can not move !");
			
			var isSame:Boolean=true;
			for(var i:int=0;i< lastVectex.length;i++)
			{
				if(lastVectex[i]!=_thisRoom._vertexVec1[i])
				{
					isSame=false;
					break;
				}
			}
			if(!isSame)
				CommandManager.Instance.MoveRoomVertex(_thisRoom,lastVectex,_thisRoom._vertexVec1);
			
			bLeftMouseDown=false;
			HideCursorCorner();
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP,LeftMouseUp);
			}
			
			_thisRoom.CheckVertexData();
		}
		private function MouseMove(e:MouseEvent):void
		{
			if(!_selected || !bLeftMouseDown)
				return;
		
			ShowCursorCorner(new Point(this.mouseX,this.mouseY),_rotation);
			
			if(MoveWall(_postionInRoom))
			{
				lastMousePoint.x=this.mouseX;
				lastMousePoint.y=this.mouseY;
				_thisRoom._bSplit=false;//移动过后，拆分标志就为false
			}
		}
		
		
		private function MoveWall(pos:int):Boolean
		{
			var vecLen:int=_thisRoom._vertexVec1.length;
			var P0:Point=new Point(_thisRoom._vertexVec1[(pos+0)%vecLen],-_thisRoom._vertexVec1[(pos+1)%vecLen]);
			var P1:Point=new Point(_thisRoom._vertexVec1[(pos+2)%vecLen],-_thisRoom._vertexVec1[(pos+3)%vecLen]);
			var P2:Point=new Point(_thisRoom._vertexVec1[(pos+4)%vecLen],-_thisRoom._vertexVec1[(pos+5)%vecLen]);
			var P3:Point=new Point(_thisRoom._vertexVec1[(pos+6)%vecLen],-_thisRoom._vertexVec1[(pos+7)%vecLen]);    
			trace("P0123:"+P0+P1+P2+P3);
			
			//1.求鼠标移动的向量
			var VMouseMove:Point=new Point((int)(this.mouseX-lastMousePoint.x),int(this.mouseY-lastMousePoint.y));

			//1.求移动的P1P2线段
			var VP1P2:Point=new Point(P2.x-P1.x,P2.y-P1.y);
			trace("VP1P2:"+VP1P2);
			
			//1.求P1P2线段逆时针方向法线向量
			var VP1P2_Normal:Point= new Point(-VP1P2.y,VP1P2.x);
			trace("VP1P2_Normal:"+VP1P2_Normal);
			
			//1求夹角，P1P2_Normal和 MouseMove。
			var d:Number=VP1P2_Normal.x*VMouseMove.x+VP1P2_Normal.y*VMouseMove.y;
			var d1:Number=Math.sqrt(VP1P2_Normal.x*VP1P2_Normal.x+VP1P2_Normal.y*VP1P2_Normal.y) * Math.sqrt(VMouseMove.x*VMouseMove.x+VMouseMove.y*VMouseMove.y);
			var VMouseMove_arg:Number= Math.acos(d/d1);
			var cos:Number=d/d1;
			
			trace("mouse_move to normal arg:"+VMouseMove_arg);
			trace("mouse_move to normal ang:"+VMouseMove_arg*180/Math.PI);
			
			//2 P1P2 直线方程  Ax+By+c=0的表达式
			
			var A:Number=(P2.y-P1.y);
			
			var B:Number=(P1.x-P2.x);
			
			var C:Number = P2.x*P1.y-P1.x*P2.y;
			
			trace("ABC:"+A+B+C);
			
			//2求平移后的直线  |C1-C0|/sqrt（A*A+B*B）=DIS
			
			var aabb:Number=Math.sqrt(A*A+B*B);
			
			var dis:Number=Math.sqrt( VMouseMove .x*  VMouseMove .x+  VMouseMove .y*  VMouseMove .y)*cos;
			
			
			var s:Number=dis*aabb;
			
			var C2:Number=C+s;
			trace("C2:"+C2);
			
			
			
			//求POP1，P3P2和  AX+BY+C2 两个交点
			var i1:Point=Object2D_Utility.Intersection2(P0,P1,A,B,C2);
			
			var i2:Point=Object2D_Utility.Intersection2(P3,P2,A,B,C2);
			
		
			
			if(i1.x!=Number.POSITIVE_INFINITY && i2.x!=Number.POSITIVE_INFINITY)
			{
				var vertex:Vector.<Number>=new Vector.<Number>;
				for(var j:int=0;j<_thisRoom._vertexVec1.length;j++)
					vertex.push(_thisRoom._vertexVec1[j]);
				
				vertex[(pos+2)%vecLen]=(int)(i1.x);
				
				vertex[(pos+3)%vecLen]=(int)(-i1.y);
				
				vertex[(pos+4)%vecLen]=(int)(i2.x);
				
				vertex[(pos+5)%vecLen]=(int)(-i2.y);
				
				for(j=0;j<vertex.length;j+=2)
				{
					var isInter:Boolean=Object2D_Utility.SelfIntersection(vertex,j);
					if(isInter)
						return false;
				}
								
				_thisRoom._vertexVec1[(pos+2)%vecLen]=(int)(i1.x);
				
				_thisRoom._vertexVec1[(pos+3)%vecLen]=(int)(-i1.y);
				
				_thisRoom._vertexVec1[(pos+4)%vecLen]=(int)(i2.x);
				
				_thisRoom._vertexVec1[(pos+5)%vecLen]=(int)(-i2.y);
				
				_thisRoom.Object2DUpdate();
				
				return true;
				
			}
			
			return false;
		}

	}
}