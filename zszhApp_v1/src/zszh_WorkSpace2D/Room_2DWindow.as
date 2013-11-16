package zszh_WorkSpace2D
{

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	import zszh_WorkSpace2D.PopupMenu_Room2D_Wall;
	
	public class Room_2DWindow extends Object2D_Base
	{
		private var _popupWindowMenu:PopupMenu_Room2D_Wall;
		
		private var _lineColor:uint;
		private var _lineColorSelected:uint;
		private var _windowColor:uint;
		
		private var _thisWall:Room_2DWall;
		
		public function Room_2DWindow(p0:Point,p1:Point,resourcePath:String,modelName:String)
		{
			super();
			
			_lineColor=0xff0000;
			_lineColorSelected=0x00ff00;
			_windowColor=0xffff00;
			
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
			addEventListener(Event.ADDED,OnAdd);
			addEventListener(MouseEvent.RIGHT_CLICK,MouseCLICK);
			addEventListener(MouseEvent.MOUSE_OVER,MouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,MouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
		}
	
		private function OnAdd(event:Event):void
		{
			_thisWall=(this.parent as Room_2DWall);
		}
		private function OnCreation_Complete(e:FlexEvent):void
		{
			Draw();
		}
		override public function Draw():void
		{
			if(!_thisWall)
				_thisWall=(this.parent as Room_2DWall);
			var p:Point=new Point(this.x,this.y);
			var pos:Point=Object2D_Utility.FindShortestPoint(_thisWall._wallVertex1,p);
			

			
			this.x=pos.x;
			this.y=pos.y;
			
			graphics.clear();
			graphics.lineStyle(1,_lineColor);//白线
			graphics.beginFill(_windowColor,0.8);
			graphics.drawRect(-10,-50,20,100);
			graphics.endFill();
			
			var p1:Point=new Point(_thisWall._wallVertex1[0],_thisWall._wallVertex1[1]);
			var p2:Point=new Point(_thisWall._wallVertex1[2],_thisWall._wallVertex1[3]);
			var p2p1:Point=new Point(p2.x-p1.x,p2.y-p1.y);
			
			var pp:Point=new Point(0,100);
			
			
			//1求夹角，P1P2_Normal和 MouseMove。
			var d:Number=p2p1.x*pp.x+p2p1.y*pp.y;
			var d1:Number=Math.sqrt(p2p1.x*p2p1.x+p2p1.y*p2p1.y) * Math.sqrt(pp.x*pp.x+pp.y*pp.y);
			var arg:Number= Math.acos(d/d1);
			var ang:Number=arg*180/Math.PI;
			
			this.rotation=_thisWall._rotation-90;
			
		}
		
		
		//----------------wall mouse move event ---------------------------------------
		
		private function MouseOver(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			e.stopPropagation();
		}
		private function MouseOut(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			e.stopPropagation();
		}
		
		private function MouseCLICK(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			if(_popupWindowMenu)
			{
				PopUpManager.removePopUp(_popupWindowMenu);
				_popupWindowMenu=null;
			}
			_popupWindowMenu=new PopupMenu_Room2D_Wall();
			PopUpManager.addPopUp(_popupWindowMenu,this,false);
		
			var pt:Point = new Point(e.localX, e.localY);
			pt = e.target.localToGlobal(pt);
			_popupWindowMenu.move(pt.x,pt.y);
			e.stopPropagation();
			
		}
		
	
		private var startPoint:Point=new Point;
		private var bStart:Boolean=false;
		

		private function MouseDown(e:MouseEvent):void
		{
			if(!_selected)
				return;
		  
			bStart=true;
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
	
			
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,StageMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,StageMouseUp);
			e.stopPropagation();
		}
		
		private function StageMouseUp(e:MouseEvent):void
		{
		  	SetSelected(true);
			bStart=false;

			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,StageMouseMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,StageMouseUp);
		}
		private function StageMouseMove(e:MouseEvent):void
		{
			if(!_selected)
				return;
			
			if(!bStart)
				return;
			startPoint.x=this.mouseX;
			startPoint.y=this.mouseY;
		}
		
		
	}
}