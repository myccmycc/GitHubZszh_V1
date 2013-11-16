package zszh_WorkSpace3D
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
 
	public class WorkSpace3D_SmallView extends UIComponent
	{

		public var _view3d:View3D;
		private var _camera:Camera3D;
		public var _cameraController:HoverController;
		
		//navigation variables
		public var _cameraMove:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		
		
		public function WorkSpace3D_SmallView()
		{ 
			_view3d=new View3D();
			_view3d.backgroundAlpha=0;
			_view3d.backgroundColor=0x303344;
			_view3d.antiAlias=4;
			addChild(_view3d);
			
			// cubes
			var cubeGeometry:CubeGeometry = new CubeGeometry(200,200,200, 10, 10, 10);
			var cubeMaterial:ColorMaterial = new ColorMaterial( 0x535564 );
			//cubeMaterial.lightPicker = lightPicker;
			var mesh:Mesh = new Mesh(cubeGeometry, cubeMaterial);
			mesh.showBounds=true;
			mesh.bounds.boundingRenderable.color = 0x449ebe;
			_view3d.scene.addChild(mesh);
			
			var lens:OrthographicLens = new OrthographicLens();
			_camera = new Camera3D(lens);
			_camera.lens
			_view3d.camera = _camera;
			//setup controller to be used on the camera
			_cameraController = new HoverController(_camera, mesh, 180,60, 800);
			_cameraController.maxTiltAngle=45;
			_cameraController.minTiltAngle=25;
			
			//setup camera controller
			_view3d.addEventListener(MouseEvent.MOUSE_DOWN,MOUSE_DOWN_view3d);
			addEventListener(Event.ENTER_FRAME,OnFrameEnter);
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
			}
			
			
			if (_cameraMove) {
				_cameraController.panAngle = (mouseX - lastMouseX) + lastPanAngle;
				_cameraController.tiltAngle = (mouseY - lastMouseY) + lastTiltAngle;
			}
		}
		
		
		//-----------------mouse event---------------------------------------------
		/**
		 * _view3d listener for mouse interaction
		 */
		//左键
		private var _bMDown_view3d:Boolean=false;
		private var _MDownPos:Point=new Point(0,0);
		private var _MDownCameraPos:Point=new Point(0,0);
		
		private function MOUSE_DOWN_view3d(ev:MouseEvent) : void
		{
			_bMDown_view3d=true;
			_MDownPos.x=ev.localX;
			_MDownPos.y=ev.localY;
			
			_MDownCameraPos.x=_view3d.camera.x;
			_MDownCameraPos.y=_view3d.camera.z;
			
			lastPanAngle = _cameraController.panAngle;
			lastTiltAngle = _cameraController.tiltAngle;
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			_cameraMove = true;
			addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			addEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			addEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			
		}
		private function MOUSE_UP_view3d(ev:MouseEvent) : void
		{
			_bMDown_view3d=false;			
			_cameraMove = false;
			removeEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onStageMouseLeave(event:Event):void
		{
			_cameraMove = false;
			removeEventListener(MouseEvent.MOUSE_OUT,MOUSE_UP_view3d);
			removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP_view3d);
			removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
	}
}