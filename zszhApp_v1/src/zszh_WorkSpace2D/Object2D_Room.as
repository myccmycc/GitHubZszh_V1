package zszh_WorkSpace2D
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import zszh_Core.CommandManager;

	public class Object2D_Room extends Object2D_Base
	{
		public  var _vertexVec1:Vector.<Number>;
		public  var _vertexVec2:Vector.<Number>;
		public  var _vertexVec3:Vector.<Number>;
		
		public  var _floor:Room_2DFloor;
		
		private var _roomType:String;//0小,1大,2L,3room
		private var _wallWidth:int;
		
		public function Object2D_Room(roomType:String,_vertexData:Vector.<Number>=null)
		{
			super();
			_vertexVec1=new Vector.<Number>();
			
			if(_vertexData!=null&&roomType=="0")
				_vertexVec1=_vertexData;
			else if(_vertexData!=null&&roomType!="0")
				trace("error: Object2D_Room if construct _vertexData!=null , roomType should is '0'.");
			
			_roomType=roomType;		
			_wallWidth=20;
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreationComplete);
		}
		
		private function OnCreationComplete(e:FlexEvent):void
		{
			
			if(_roomType=="4")
			{
				_vertexVec1.push(-100,100,100,100,100,-100,-100,-100);
			}
			else if(_roomType=="1")
			{
				_vertexVec1.push(-220,220,220,220,220,-220,-220,-220);
			}
				
			else if(_roomType=="2")
			{
				_vertexVec1.push(0,0, 200,0, 200,-200, -200,-200,  -200,200, 0,200);
			}
				
			else if(_roomType=="3")
			{
				_vertexVec1.push(0,400, 500,400, 500,-300, 0,-300, 0,-500, -500,-500, -500,500, 0,500);
			}
			
			UpdateVertexData();
			
			CreateRoom();
			
			Draw();
			
		}
		
		//消除多余的定点  1。相同的点 2在同一直线上的点
		//拆分
		public var _bSplit:Boolean=false;
		public function CheckVertexData():void
		{
			if(_bSplit)
				return;

			var newVectex:Vector.<Number>=new Vector.<Number>;
			Object2D_Utility.CheckVertexData(_vertexVec1,newVectex);
			
			if(newVectex.length!=_vertexVec1.length)
				CommandManager.Instance.ChangeRoomVertex(this,_vertexVec1,newVectex);
		}
		
		
		public function UpdateVertexData():void
		{
			_vertexVec2=new Vector.<Number>;
			_vertexVec3=new Vector.<Number>;
			Object2D_Utility.ScaleVertexData(_vertexVec1,_vertexVec2,-_wallWidth/2);
			Object2D_Utility.ScaleVertexData(_vertexVec1,_vertexVec3,_wallWidth/2);
		}
		
		public function CreateRoom():void
		{
			//clear room
			if(numChildren>0)
				removeChildren(0,numChildren-1);

			//floor
			_floor=new Room_2DFloor();
			addChild(_floor);
			
			//walls
			var len:int=_vertexVec1.length;
			for(var i:int=0;i<len;i+=2)
			{
				var wall:Room_2DWall=new Room_2DWall();
				wall._postionInRoom=i;
				addChild(wall);
			}
			
			//corners
			for(i=0;i<len;i+=2)
			{
				var wallCorner:Room_2DCorner=new Room_2DCorner();
				wallCorner._posInRoom=i;
				addChild(wallCorner);
			}

		}
		
		override public function Draw():void
		{
			
			UpdateVertexData();
			
			for(var i:int=0;i<numChildren;i++)
				(getChildAt(i) as Object2D_Base).Draw();
		}
		
		
		public function DeleteThisRoom():void
		{
			CommandManager.Instance.Delete(this.parent as UIComponent,this);
		}
		
		public function SetAllSelected(b:Boolean):void
		{
			for(var i:int=0;i<numChildren;i++)
				(getChildAt(i) as Object2D_Base).SetSelected(b);

		}
	
		override public function Object2DUpdate():void
		{
			SetAllSelected(_selected);
			Draw();
		}
		
	}
}