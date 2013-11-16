package zszh_WorkSpace3D
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.data.EntityListItem;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.assets.AssetType;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.utils.Cast;
	
	import zszh_WorkSpace2D.Object2D_Model;
	import zszh_WorkSpace2D.Object2D_Room;
	
	import zszh_WorkSpace3D.WorkSpace3D;
	
	public class ModelOnWall_3D extends ObjectContainer3D
	{
		public var _resPath:String;
		public var _modelName:String;
		private var _rotation:int;
		
		public var _loaderModel:Loader3D;
		private var _mesh:Mesh;
		private var _specularTex:String;private var _speculaLoader:Loader;
		private var _normalTex:String;	private var _normalLoader:Loader;
		private var _lightPicker:StaticLightPicker;
		
	
		
		public function ModelOnWall_3D(resPath:String,modelName:String,pos:Vector3D,rotation:int,lightPick:StaticLightPicker)
		{
			super();
			_resPath=resPath;
			_modelName=modelName;
			position=pos;
			_rotation=rotation;
			
			yaw(_rotation);
			_lightPicker=lightPick;
			//Loader3D to load the asset
			Loader3D.enableParser(AWD2Parser);
			_loaderModel= new Loader3D();
			var modelFile:String=_resPath+_modelName+".awd";
			_loaderModel.load(new URLRequest(modelFile));
		
			_loaderModel.addEventListener(AssetEvent.MESH_COMPLETE,OnMeshAssetComplete);
			_loaderModel.addEventListener(LoaderEvent.LOAD_ERROR,ModelLoadError);
			
			
			_specularTex=_resPath+"texture_specular.jpg";
			_normalTex=_resPath+"texture_normal.jpg";
			

		}
		
		private function onCompleteSpecular(e:Event):void
		{
			var mat:TextureMaterial=_mesh.material as TextureMaterial;
			mat.specularMap=Cast.bitmapTexture(_speculaLoader.content);
		}
		
		private function onCompleteNormal(e:Event):void
		{
			var mat:TextureMaterial=_mesh.material as TextureMaterial;
			mat.normalMap=Cast.bitmapTexture(_normalLoader.content);
		}
		
		private function OnMeshAssetComplete(event:AssetEvent):void
		{
			if(event.asset.assetType==AssetType.MESH)
			{
				_mesh = event.asset as Mesh;
				_mesh.mouseEnabled = true;
				_mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, MeshMouseDown);
				_mesh.addEventListener(MouseEvent3D.MOUSE_OUT, MeshMouseUp);
				_mesh.addEventListener(MouseEvent3D.MOUSE_UP, MeshMouseUp);
				_mesh.scale(0.2);
				addChild(_mesh);
				
				var mat:TextureMaterial=_mesh.material as TextureMaterial;
				mat.lightPicker=_lightPicker;
				
				_speculaLoader=new Loader;
				_speculaLoader.load(new URLRequest(_specularTex));
				_speculaLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteSpecular);
				
				_normalLoader=new Loader;
				_normalLoader.load(new URLRequest(_normalTex));
				_normalLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteNormal);
			}
		}
	
		private function ModelLoadError(event:LoaderEvent):void
		{
			trace("ERROR:ModelLoadError "+event.url);
		}

		
		private var startPoint:Point;
		private var bStart:Boolean=false;
		private function MeshMouseDown(e:MouseEvent3D):void
		{
			e.target.showBounds=true;
			startPoint=new Point;
			bStart=true;
			startPoint.x=e.scenePosition.x;
			startPoint.y=e.scenePosition.z;
			
			//e.target.addEventListener(MouseEvent3D.MOUSE_MOVE, MeshMouseMove);
			
			WorkSpace3D.gCurrentObj3D=this;
			
			trace("MeshMouseDown");
			trace(e.screenX);
			trace(e.screenY);
			/*trace(e.screenX);
			trace(e.screenY);
			trace(e.scenePosition);
			trace(e.localPosition);*/
			
			
			//update ray
			/*var rayPosition:Vector3D = e.view.unproject(e.screenX, e.screenY, 0);
			var rayDirection:Vector3D = e.view.unproject(e.screenX, e.screenY, 1);
			rayDirection = rayDirection.subtract(rayPosition);
			
			trace(rayPosition);
			trace(rayDirection);
			/*if (entity.isVisible && entity.isIntersectingRay(rayPosition, rayDirection))
			{
				
			}	*/
				
		}
		
		private function MeshMouseMove(e:MouseEvent3D):void
		{
			if(bStart)
			{
				
				var dx:Number=e.scenePosition.x-startPoint.x;
				var dz:Number=e.scenePosition.z-startPoint.y;
				
				
				e.target.parent.x+=dx;
				e.target.parent.z+=dz;
				
				startPoint.x=e.scenePosition.x;
				startPoint.y=e.scenePosition.z;
				
			}
		}
		private function MeshMouseUp(e:MouseEvent3D):void
		{
			bStart=false;
			e.target.removeEventListener(MouseEvent3D.MOUSE_MOVE, MeshMouseMove);
		}
		
	}

}