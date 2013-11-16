package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.Image;
	
	import zszh_WorkSpace3D.WorkSpace3D;
	
	public class Object2D_Model extends Object2D_Base
	{
		private var _topImageParent:UIComponent;
		public  var _topImage:Image;
		private var _topImageLoader:Loader;
		
		private var _boundsColor:uint;
		private var _boundWidth:int;
		private var _boundHeight:int;
		
		public var _resourcePath:String;
		public var _modelName:String;
		
		private var _popupMenu:PopupMenu_Mode2D;
		
		
		[Bindable]
		[Embed(source="../embeds/rooms/cursor_corner.png")]
		private var _rotationIcon:Class;
		private var _rotationSprite:Sprite;
		public  var _rotation:int;
		
		
		public function Object2D_Model(resourcePath:String,modelName:String)
		{
			super();
			_resourcePath=resourcePath;
			_modelName=modelName;
			
			_rotationSprite=new Sprite();
			var img:Bitmap=new _rotationIcon();
			_rotationSprite.addChild(img);
			img.x=-img.width/2;
			img.y=-img.height/2;
			addChild(_rotationSprite);
			_rotationSprite.visible=false;
			_rotationSprite.addEventListener(MouseEvent.MOUSE_DOWN,MouseDownRotation);
			
			_rotation=0;
			_boundsColor=0xffffff;
			_boundWidth=0;
			_boundHeight=0;
			
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		
		private function OnCreation_Complete(e:FlexEvent):void
		{
			_topImageLoader = new Loader();
			_topImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			var topImageFile:String=_resourcePath+"top.png"
			_topImageLoader.load(new URLRequest(topImageFile));
			
			function onComplete(e:Event):void
			{
				_topImage=new Image();
				_topImage.source=Bitmap(_topImageLoader.content);
				_topImage.width=_topImageLoader.content.width;
				_topImage.height=_topImageLoader.content.height;
				_topImage.x=-_topImage.width/2;
				_topImage.y=-_topImage.height/2;
				
				_boundWidth=_topImage.width;
				_boundHeight=_topImage.height;
				
				_topImageParent=new UIComponent;
				_topImageParent.addChild(_topImage);
				addChild(_topImageParent);
				
				_rotationSprite.x=0;
				_rotationSprite.y=_topImage.height/2+100;
			}
			addEventListener(MouseEvent.MOUSE_DOWN,MouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE,MouseMove);
			addEventListener(MouseEvent.MOUSE_UP,MouseUp);
			addEventListener(MouseEvent.MOUSE_OUT,MouseUp);
			addEventListener(MouseEvent.RIGHT_CLICK,MouseCLICK);	
		}	
		
		override public function Object2DUpdate():void
		{
			if(_popupMenu)
				PopUpManager.removePopUp(_popupMenu);
			
			if(_selected)
			{
				_topImage.graphics.clear();
				_topImage.graphics.lineStyle(1,_boundsColor);//白线
				_topImage.graphics.drawRect(0,0,_boundWidth,_boundHeight);
				_topImage.graphics.moveTo(_boundWidth/2,_boundHeight/2);
				_topImage.graphics.endFill();
				
				graphics.clear();
				graphics.lineStyle(1,_boundsColor);//白线
				graphics.moveTo(0,0);
				graphics.lineTo(_rotationSprite.x,_rotationSprite.y);
				graphics.endFill();
				
				_rotationSprite.visible=true;
				_topImageParent.rotation=_rotation;
			}
			else
			{
				_topImage.graphics.clear();
				_topImage.graphics.endFill();
				graphics.clear();
				graphics.endFill();
				_rotationSprite.visible=false;
			}
		}
		
		private var _bMouseDRota:Boolean=false;
		private var _lastPoint:Point=new Point;
		private function MouseDownRotation(e:MouseEvent):void
		{
			_bMouseDRota=true;
			_lastPoint.x=this.mouseX;
			_lastPoint.y=this.mouseY;
			
			addEventListener(Event.ENTER_FRAME,OnRotation);
			addEventListener(MouseEvent.MOUSE_UP,MouseUpRotation);
			e.stopPropagation();
		}
		
		private function OnRotation(e:Event):void
		{
			if(_bMouseDRota==false)
				return;
			
			_rotationSprite.x=this.mouseX;
			_rotationSprite.y=this.mouseY;
			
			var vec1:Point=new Point(0,10);
			var vec2:Point=new Point(_rotationSprite.x,_rotationSprite.y);
			
			_rotation=Object2D_Utility.GetAngle(vec1,vec2);
			SetSelected(true);
		}
		
		private function MouseUpRotation(e:MouseEvent):void
		{
			_bMouseDRota=false;
			SetSelected(true);	
			
			var dis:Number=Math.abs(2*200*Math.sin(_rotation*Math.PI/360));
			_rotationSprite.x=-dis*Math.cos(_rotation*Math.PI/360);
			_rotationSprite.y=200-dis*Math.sin(_rotation*Math.PI/360);
			
			removeEventListener(Event.ENTER_FRAME,OnRotation);
			removeEventListener(MouseEvent.MOUSE_UP,MouseUpRotation);
			e.stopPropagation();
		}
		
		
		private var _bMouseDown:Boolean=false;
		private function MouseDown(e:MouseEvent):void
		{
			//set to top show
			
			var room_2d:Object2D_Room=(this.parent as Object2D_Room);
			room_2d.setChildIndex(this,room_2d.numChildren-1);
			
			
			var _work2D:WorkSpace2D=parentApplication.GetWorkSpace2D();
			_work2D.SetAllNoSelected();
			
			_bMouseDown=true;
			SetSelected(true);
			
			
			e.stopPropagation();
		}
		private function MouseMove(e:MouseEvent):void
		{
			if(_bMouseDown)
				startDrag(false);
			e.stopPropagation();
		}
		private function MouseUp(e:MouseEvent):void
		{
			_bMouseDown=false;
			stopDrag();
			e.stopPropagation();
		}
		
		
		
		private function MouseCLICK(e:MouseEvent):void
		{
			SetSelected(true);
			_popupMenu=new PopupMenu_Mode2D;
			PopUpManager.addPopUp(_popupMenu,this,false);
			
			var pt:Point = new Point(e.target.x+e.target.width/2, e.target.y+e.target.height/2);
			pt = e.target.localToGlobal(pt);
			_popupMenu.move(pt.x,pt.y);
			e.stopPropagation();
		}
		
	}
}