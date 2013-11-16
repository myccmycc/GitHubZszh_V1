package zszh_WorkSpace3D
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.core.base.SubMesh;
	import away3d.core.math.MathConsts;
	import away3d.core.math.Plane3D;
	import away3d.debug.AwayStats;
	import away3d.debug.Trident;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.library.assets.IAsset;
	import away3d.library.utils.AssetLibraryIterator;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.TextureMultiPassMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.WireframeCube;
	import away3d.textures.Texture2DBase;
	import away3d.tools.utils.Bounds;
	import away3d.tools.utils.Ray;
	import away3d.utils.Cast;
	
	import zszh_Core.CommandManager;
	
	import zszh_WorkSpace2D.Object2D_InWall;
	import zszh_WorkSpace2D.Object2D_Model;
	import zszh_WorkSpace2D.Object2D_Room;
	import zszh_WorkSpace2D.Room_2DDoor;
	import zszh_WorkSpace2D.Room_2DWall;
	
	import zszh_WorkSpace3D.WorkSpace3D_SmallView;
	
	public class WorkSpace3D extends UIComponent
	{
		public static var gCurrentObj3D:ObjectContainer3D;
		//engine variables
		private var _view3d:View3D;
		private var _camera:Camera3D;
		private var _hoverController:HoverController;
		private var _fpsController:FirstPersonController;

		
		
		private var _directionLight:DirectionalLight;
		private var _pointLight:PointLight;
		public var _lightPicker:StaticLightPicker;
		

		//debug 
		private var _debug:AwayStats;
		//rooms
		private var _roomContainer3D:ObjectContainer3D;
		//wallInside
		private var _wallInsideContainer3D:ObjectContainer3D;
		//models
		public var _modelsContainer3D:ObjectContainer3D;
		
		//Center 
		public var _cameraCenter:ObjectContainer3D;
		public var _centerPos:Vector3D;
		

		
		private var _smallView:WorkSpace3D_SmallView;
		
		
		public function WorkSpace3D()
		{
			super();  
 			addEventListener(DragEvent.DRAG_ENTER,OnDragEnter);
			addEventListener(DragEvent.DRAG_DROP,OnDragDrop);
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}

		
		//--------------init the workspace3d-------------------------
		private function OnCreation_Complete(e:FlexEvent):void
		{
		
			_view3d=new View3D();
			_view3d.backgroundColor=0x303344;
			_view3d.antiAlias=4;
			addChild(_view3d);
			
			addEventListener(Event.ENTER_FRAME,OnFrameEnter);
						
			//setup debuh info
			//_debug=new AwayStats(_view3d);
			//addChild(_debug);
			
			_camera = new Camera3D();
			_view3d.camera = _camera;

			//setup controller to be used on the camera
			_cameraCenter=new ObjectContainer3D();
			_cameraCenter.addChild(new Trident(50));
			_view3d.scene.addChild(_cameraCenter);
			
			_hoverController = new HoverController(_camera,_cameraCenter, 180,60, 800);
			_hoverController.maxTiltAngle=45;
			_hoverController.minTiltAngle=25;
			
			//setup light
			_directionLight = new DirectionalLight();
			_directionLight.direction = _view3d.camera.forwardVector;
			_directionLight.color = 0xFFFFFF;
			_directionLight.ambient = 0.2;
			_directionLight.diffuse = 0.1;
			
			_pointLight = new PointLight();
			_pointLight.y=500;
			_pointLight.x=500;
			_pointLight.color=0xFFFFFF;
			_pointLight.ambient=0.2;
			_pointLight.diffuse=0.5;
			_pointLight.specular=0.5;
			
			_view3d.scene.addChild(_directionLight);
			_view3d.scene.addChild(_pointLight);
			
			_lightPicker = new StaticLightPicker([_pointLight,_directionLight]);
			
							
			_view3d.addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_view3d);
			_view3d.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,MIDDLE_MOUSE_DOWN_view3d);
			_view3d.addEventListener(MouseEvent.MOUSE_WHEEL,MOUSE_WHEEL_view3d);
			
			//setup the scene
			_roomContainer3D = new ObjectContainer3D();
			_wallInsideContainer3D=new ObjectContainer3D();
			_modelsContainer3D= new ObjectContainer3D();
			
			_view3d.scene.addChild(_roomContainer3D);
			_view3d.scene.addChild(_wallInsideContainer3D);
			_view3d.scene.addChild(_modelsContainer3D);
			
			_smallView=new WorkSpace3D_SmallView();
			_smallView.width=150;
			_smallView.height=150;
			_smallView.x = unscaledWidth-250;
			_smallView.y = 100 ;
			addChild(_smallView);

		}
		

		
		private function OnFrameEnter(e:Event):void
		{
			
			if(_view3d)
			{
				_view3d.width = unscaledWidth;
				_view3d.height = unscaledHeight ;
			}
			
			if(_view3d.stage3DProxy)
			{
				_view3d.render();
				_pointLight.position= _view3d.camera.position;
				_directionLight.direction = _view3d.camera.forwardVector;
			}
			
			
			if (_hoverController&&_smallView._cameraMove) {
				
				_hoverController.panAngle = 	_smallView._cameraController.panAngle;
				_hoverController.tiltAngle =   _smallView._cameraController.tiltAngle;
			}
			
			if (fpsMove&&_fpsController) {
				_fpsController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				_fpsController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
				
			}
			
			
			if(_fpsController)
			{
				if (walkSpeed || walkAcceleration) {
					walkSpeed = (walkSpeed + walkAcceleration)*drag;
					if (Math.abs(walkSpeed) < 0.01)
						walkSpeed = 0;
					_fpsController.incrementWalk(walkSpeed);
				}
				
				if (strafeSpeed || strafeAcceleration) {
					strafeSpeed = (strafeSpeed + strafeAcceleration)*drag;
					if (Math.abs(strafeSpeed) < 0.01)
						strafeSpeed = 0;
					_fpsController.incrementStrafe(strafeSpeed);
				}
			}
		}
		
		
		//-----------------mouse event---------------------------------------------
		//左键
		private var _bMouseDown:Boolean=false;
		private var _bFirstIn:Boolean=true;
		private var _MouseDownPos:Vector3D=new Vector3D;
		

		//fpsControl
		//rotation variables
		private var fpsMove:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		private function MOUSE_DOWN_view3d(event:MouseEvent):void
		{
			if(_fpsController)
			{
				fpsMove = true;
				lastPanAngle = _fpsController.panAngle;
				lastTiltAngle = _fpsController.tiltAngle;
				lastMouseX = stage.mouseX;
				lastMouseY = stage.mouseY;
				stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
				_view3d.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
				_view3d.addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			}
			
			else 
			{
				_bMouseDown=true;
				gCurrentObj3D=null;
				_bFirstIn=true;
			
				_view3d.addEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_view3d);
				_view3d.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
				_view3d.addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			}
		}
	
		
		private function MOUSE_MOVE_view3d(event:MouseEvent) : void
		{
			if(_bMouseDown&&gCurrentObj3D)
			{
				var screenX:Number=2*this.mouseX/this.unscaledWidth-1;
				var screenY:Number=2*this.mouseY/this.unscaledHeight-1;
				var cameraRay:Vector3D=_camera.getRay(screenX,screenY,1);
				trace(_camera.scenePosition);
				trace(cameraRay);

				var planeNormal:Vector3D=new Vector3D(0,1,0);
				
				var bound:Bounds=new Bounds;
				Bounds.getObjectContainerBounds(gCurrentObj3D)
				var planePos:Vector3D=new Vector3D(0,gCurrentObj3D.y+Bounds.height,0);
				var t:Number=(planeNormal.dotProduct(planePos)-planeNormal.dotProduct(_camera.scenePosition))/planeNormal.dotProduct(cameraRay);

				var interP:Vector3D=new Vector3D;
				interP.x=_camera.scenePosition.x+cameraRay.x*t;
				interP.y=_camera.scenePosition.y+cameraRay.y*t;
				interP.z=_camera.scenePosition.z+cameraRay.z*t;
				
				if(_bFirstIn)
				{
					_bFirstIn=false;
					_MouseDownPos=interP;
				}
				else 
				{
					gCurrentObj3D.x+=interP.x-_MouseDownPos.x;
					gCurrentObj3D.z+=interP.z-_MouseDownPos.z;
					_MouseDownPos=interP;
				}
				
				//var plane:Plane3D=new Plane3D();
				//plane.fromNormalAndPoint(new Vector3D(0,1,0),new Vector3D(0,gCurrentObj3D.y,0) );
				
				
				
				/*var dest:Vector3D=this._camera.unproject(screenX,screenY,100);
				
				var dest2:Vector3D=new Vector3D(_camera.scenePosition.x+cameraRay.x,_camera.scenePosition.y+cameraRay.y,_camera.scenePosition.z+cameraRay.z);
				
				var plane:Plane3D=new Plane3D();
				plane.fromNormalAndPoint(new Vector3D(0,1,0),new Vector3D(0,gCurrentObj3D.y,0) );
				
				var ray:Ray=new Ray;
				var v0:Vector3D = new Vector3D(1,gCurrentObj3D.y,0);
				var v1:Vector3D = new Vector3D(0,gCurrentObj3D.y,1);
				var v2:Vector3D = new Vector3D(0,gCurrentObj3D.y,0);
				
				
				var intersect:Vector3D = ray.getRayToTriangleIntersection(this._camera.position, dest, v0, v1, v2 );
				trace("intersect ray: "+intersect);
				
				
				var p1:Vector3D=this._camera.project(gCurrentObj3D.scenePosition);
				
				trace(gCurrentObj3D.position);
				trace(gCurrentObj3D.scenePosition);
				
				var p2:Vector3D=this._camera.unproject(p1.x,p1.y,p1.z);
				
				trace(p2);
				
				var intersect2:Vector3D = ray.getRayToTriangleIntersection(this._camera.scenePosition, new Vector3D(0,0,0), v0, v1, v2 );
				
				var v0:Vector3D = new Vector3D(1,0,0);
				var v1:Vector3D = new Vector3D(0,0,1);
				var v2:Vector3D = new Vector3D(0,0,0);
				var intersect2:Vector3D = ray.getRayToTriangleIntersection(this._camera.scenePosition, new Vector3D(0,1,0), v0, v1, v2 );
				//gCurrentObj3D.x=intersect.x;
				//gCurrentObj3D.y=intersection.y;
				//gCurrentObj3D.z=intersect.z;*/
			}
			
			else if(_bMidMouseDown)
			{
				
				_cameraCenter.x-=(event.localX-_MMDownPos.x)*10;
				_cameraCenter.z+=(event.localY-_MMDownPos.y)*10;
				
				_MMDownPos.x=event.localX;
				_MMDownPos.y=event.localY;
			}
		}
		
		
		private function MOUSE_UP_view3d(event:MouseEvent):void
		{
			
			if(_fpsController)
			{
				fpsMove = false;
				stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			}
			else 
			{
				_bMouseDown=false;
				_bMidMouseDown=false;
			
				_view3d.removeEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_view3d);
				_view3d.removeEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
				_view3d.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP,MOUSE_UP_view3d);
				_view3d.removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			}
		}

		private function onStageMouseLeave(event:Event):void
		{
			fpsMove = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		//中键
		private var _bMidMouseDown:Boolean=false;
		private var _MMDownPos:Point=new Point(0,0);
		private var _MMDownCameraPos:Point=new Point(0,0);
		private function MIDDLE_MOUSE_DOWN_view3d(event:MouseEvent):void
		{
			if(!_hoverController)
				return;
			
			_bMidMouseDown=true;
			_MMDownPos.x=event.localX;
			_MMDownPos.y=event.localY;
			
			_view3d.addEventListener(MouseEvent.MOUSE_MOVE,MOUSE_MOVE_view3d);
			_view3d.addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			_view3d.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,MOUSE_UP_view3d);
			
		}
		//滚轮
		private function MOUSE_WHEEL_view3d(ev:MouseEvent) : void
		{
			if(!_hoverController)
				return;
			
			if(ev.delta<0&&_hoverController.distance<1200)
			{
				_hoverController.distance+=20;
			}
			else if(_hoverController.distance>500)
			{
				_hoverController.distance-=20;
			}				
		}
		
		
		
		
		
		
		//----------------D&D-------------------
		private static var currentMesh:Mesh=null;
		private static var currentPos:Vector3D;
		
		private function OnDragEnter(event:DragEvent):void
		{
			DragManager.acceptDragDrop(event.target as UIComponent);
		}
		
		private function OnDragDrop(event:DragEvent):void
		{
			var className:String=String(event.dragSource.dataForFormat("className"));
			var classArgument:String=String(event.dragSource.dataForFormat("classArgument"));
			var resourcePath:String=String(event.dragSource.dataForFormat("resourcePath"));
			var objectName:String=String(event.dragSource.dataForFormat("objectName"));
			
			
			if(className=="rujiaoqi")
			{
				 
				var wallTex:String=resourcePath+"texture.jpg";
				
				var wallTexLoader:Loader = new Loader();
				wallTexLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				wallTexLoader.load(new URLRequest(wallTex));
				
				function onComplete(e:Event):void
				{
					var wallBitmap:Bitmap = Bitmap(wallTexLoader.content);
					var wallMaterial:MaterialBase = new TextureMaterial(Cast.bitmapTexture(wallBitmap));
					
					var wall:Mesh=GetCurrentWallMesh();
					if(wall)
						wall.material=wallMaterial;
				}
				
			}
			
			
			else if(className=="modelOnWall")
			{
				var wall:Mesh=GetCurrentWallMesh();
				if(wall)
				{
					/*var screenX:Number=2*this.mouseX/this.unscaledWidth-1;
					var screenY:Number=2*this.mouseY/this.unscaledHeight-1;
					var cameraRay:Vector3D=_camera.getRay(screenX,screenY,1);
					trace(_camera.scenePosition);
					trace(cameraRay);
					
					wall.
					
					var planeNormal:Vector3D=new Vector3D(0,1,0);
					
					var bound:Bounds=new Bounds;
					Bounds.getObjectContainerBounds(gCurrentObj3D)
					var planePos:Vector3D=new Vector3D(0,gCurrentObj3D.y+Bounds.height,0);
					var t:Number=(planeNormal.dotProduct(planePos)-planeNormal.dotProduct(_camera.scenePosition))/planeNormal.dotProduct(cameraRay);
					
					var interP:Vector3D=new Vector3D;
					interP.x=_camera.scenePosition.x+cameraRay.x*t;
					interP.y=_camera.scenePosition.y+cameraRay.y*t;
					interP.z=_camera.scenePosition.z+cameraRay.z*t;
					
					if(_bFirstIn)
					{
						_bFirstIn=false;
						_MouseDownPos=interP;
					}
					else 
					{
						gCurrentObj3D.x+=interP.x-_MouseDownPos.x;
						gCurrentObj3D.z+=interP.z-_MouseDownPos.z;
						_MouseDownPos=interP;
					}*/
					var md:ModelOnWall_3D=new ModelOnWall_3D(resourcePath,objectName,currentPos,0,_lightPicker);
					_modelsContainer3D.addChild(md);
				}
				
				
			}
		}
		
		private function GetCurrentWallMesh():Mesh
		{
			return currentMesh;
		}
		
		public static function SetCurrentWallMesh(mesh:Mesh):void
		{
			currentMesh=mesh;
		}
		
		public static function SetMousePosition(pos:Vector3D):void
		{
			currentPos=pos;
		}
		
		
		
		
		
		
		
		
		
		
		
		//--------punblic functions------------------------------------------
		
		
		
		public function ShowCenter3D():void
		{
			
		}
		
		public function ClearRoom():void
		{
			for(var i:int=_roomContainer3D.numChildren-1;i>=0;i--)
				_roomContainer3D.removeChildAt(i);
			
		}
		public function AddRoom(room:Object2D_Room):void
		{
			var room3d:Room_3D=new Room_3D(room,_lightPicker);
			_roomContainer3D.addChild(room3d);
		}
		
		public function AddRoomDoors(room:Object2D_Room):void
		{
			for(var i:int=0;i<room.numChildren;i++)
			{
				var obj:DisplayObject=room.getChildAt(i);
				
				if(obj is Room_2DWall)
				{
					var wallObj:Room_2DWall=obj as Room_2DWall;
					for(var j:int=0;j<wallObj.numChildren;j++)
					{
						obj=wallObj.getChildAt(j);
						
						if(obj is Room_2DDoor)
						{
							//var door:ModelDoor_3D=new ModelDoor_3D(obj as Room_2DDoor , room, _lightPicker);
							
							var door:ModelInWall_3D=new ModelInWall_3D(obj as Room_2DDoor , room, _lightPicker);
							_roomContainer3D.addChild(door);
						}
					}
				}
				
			}
		}
		
		

		
		public function ClearWallInside():void
		{
			for(var i:int=_wallInsideContainer3D.numChildren-1;i>=0;i--)
				_wallInsideContainer3D.removeChildAt(i);
			
		}
		public function AddWallInside(pos1:Vector.<Number>,wallName:String):void
		{
			var wallInside:WallInside_3D=new WallInside_3D(pos1,_lightPicker);
			wallInside.name=wallName;
			_wallInsideContainer3D.addChild(wallInside);
		}
		
		
		public function ClearModels():void
		{
			for(var i:int=_modelsContainer3D.numChildren-1;i>=0;i--)
				_modelsContainer3D.removeChildAt(i);
			
			//AssetLibrary.removeAllAssets();
			
		}
		
		public function AddModels(model2d:Object2D_Model,room:Object2D_Room):void
		{	
			var model3d:Model_3D=new Model_3D(model2d,room,_lightPicker);
			_modelsContainer3D.addChild(model3d);
		}
		
		
		//camera controller
		public function FPSVisit():void
		{
			
			
			_fpsController=new FirstPersonController(_camera,180, 0, -80, 80);
			_camera.position=_cameraCenter.position;
			_camera.y=270;
			//_fpsController.panAngle=_hoverController.panAngle;
			//_fpsController.tiltAngle=_hoverController.tiltAngle;
			_hoverController=null;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		
		public function NormalVisit():void
		{
			
			_hoverController = new HoverController(_camera,_cameraCenter, 180,60, 800);
			_hoverController.maxTiltAngle=45;
			_hoverController.minTiltAngle=25;
			_fpsController=null;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		//movement variables
		private var drag:Number = 0.5;
		private var walkIncrement:Number = 2;
		private var strafeIncrement:Number = 2;
		private var walkSpeed:Number = 0;
		private var strafeSpeed:Number = 0;
		private var walkAcceleration:Number = 0;
		private var strafeAcceleration:Number = 0;
		
		/**
		 * Key down listener for camera control
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
					walkAcceleration = walkIncrement;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = -walkIncrement;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					strafeAcceleration = -strafeIncrement;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = strafeIncrement;
					break;
			}
		}
		
		/**
		 * Key up listener for camera control
		 */
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = 0;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = 0;
					break;
			}
		}
		
		
	}
}