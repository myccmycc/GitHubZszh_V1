/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this service wrapper you may modify the generated sub-class of this class - ZszhmodelsService.as.
 */
package services.zszhmodelsservice
{
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.services.wrapper.RemoteObjectServiceWrapper;
import com.adobe.fiber.valueobjects.IValueObject;
import com.adobe.serializers.utility.TypeUtility;
import mx.collections.ListCollectionView;
import mx.data.DataManager;
import mx.data.IManaged;
import mx.data.ItemReference;
import mx.data.ManagedAssociation;
import mx.data.ManagedOperation;
import mx.data.ManagedQuery;
import mx.data.RPCDataManager;
import mx.data.errors.DataServiceError;
import mx.rpc.AbstractOperation;
import mx.rpc.AsyncToken;
import mx.rpc.remoting.Operation;
import mx.rpc.remoting.RemoteObject;
import valueObjects.Zszh_models;

import mx.collections.ItemResponder;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

[ExcludeClass]
internal class _Super_ZszhmodelsService extends com.adobe.fiber.services.wrapper.RemoteObjectServiceWrapper
{
    private var _zszh_modelsRPCDataManager : mx.data.RPCDataManager;
    private var managersArray : Array = new Array();

    public const DATA_MANAGER_ZSZH_MODELS : String = "Zszh_models";

    public function getDataManager(dataManagerName:String) : mx.data.RPCDataManager
    {
        switch (dataManagerName)
        {
             case (DATA_MANAGER_ZSZH_MODELS):
                return _zszh_modelsRPCDataManager;
            default:
                return null;
        }
    }

    /**
     * Commit all of the pending changes for this DataService, as well as all of the pending changes of all DataServices
     * sharing the same DataStore.  By default, a DataService shares the same DataStore with other DataServices if they have 
     * managed association properties and share the same set of channels. 
     *
     * @see mx.data.DataManager
     * @see mx.data.DataStore
     *
     * @param itemsOrCollections:Array This is an optional parameter which defaults to null when
     *  you want to commit all pending changes.  If you want to commit a subset of the pending
     *  changes use this argument to specify a list of managed ListCollectionView instances
     *  and/or managed items.  ListCollectionView objects are most typically ArrayCollections
     *  you have provided to your fill method.  The items appropriate for this method are
     *  any managed version of the item.  These are any items you retrieve from getItem, createItem
     *  or using the getItemAt method from a managed collection.  Only changes for the
     *  items defined by any of the values in this array will be committed.
     *
     * @param cascadeCommit if true, also commit changes made to any associated
     *  items supplied in this list.
     *
     *  @return AsyncToken that is returned in <code>call</code> property of
     *  either the <code>ResultEvent.RESULT</code> or in the
     *  <code>FaultEvent.FAULT</code>.
     *  Custom data can be attached to this object and inspected later
     *  during the event handling phase.  If no changes have been made
     *  to the relevant items, null is returned instead of an AsyncToken.
     */
    public function commit(itemsOrCollections:Array=null, cascadeCommit:Boolean=false):mx.rpc.AsyncToken
    {
        return _zszh_modelsRPCDataManager.dataStore.commit(itemsOrCollections, cascadeCommit);
    }

    /**
     * Reverts all pending (uncommitted) changes for this DataService, as well as all of the pending changes of all DataServics
     * sharing the same DataStore.  By default, a DataService shares the same DataStore with other DataServices if they have 
     * managed association properties and share the same set of channels. 
     *
     * In case you specify a value for itemsOrCollections:Array parameter, only pending (uncommitted) changes for the specified 
     * managed items or collections will be reverted.
     *
     * @see mx.data.DataManager
     * @see mx.data.DataStore
     * 
     * @param itemsOrCollections:Array This is an optional parameter which defaults to null 
     * when you want to revert all pending (uncommitted) changes for all DataServices
     * managed by this DataStore. If you want to revert a subset of the pending changes use 
     * this argument to specify a array of managed items or collections
     *
     * @return true if any changes were reverted.
     * @throws DataServiceError if the passed in array contains non-managed items or collections
     *  
     */
    public function revertChanges(itemsOrCollections:Array=null):Boolean
    {
        if (itemsOrCollections == null)
        {
            // Revert all changes
            return _zszh_modelsRPCDataManager.dataStore.revertChanges();
        }
        else
        {
            // Revert passed in items
            var anyChangeItemReverted:Boolean = false;

            // Iterate over array and revert managed item or collection as the case may be
            for each (var changeItem:Object in itemsOrCollections)
            {
                if (changeItem is com.adobe.fiber.valueobjects.IValueObject)
                {
                    var dataMgr:mx.data.DataManager = getDataManager(changeItem._model.getEntityName());
                    anyChangeItemReverted ||= dataMgr.revertChanges(mx.data.IManaged(changeItem))
                }
                else if (changeItem is mx.collections.ListCollectionView)
                {
                    anyChangeItemReverted ||= _zszh_modelsRPCDataManager.dataStore.revertChangesForCollection(mx.collections.ListCollectionView(changeItem));
                }
                else
                {
                    throw new mx.data.errors.DataServiceError("revertChanges called on array that contains non-managed items or collections");
                }
            }
            return anyChangeItemReverted;
        }
    }

    // Constructor
    public function _Super_ZszhmodelsService()
    {
        // initialize service control
        _serviceControl = new mx.rpc.remoting.RemoteObject();

        // initialize RemoteClass alias for all entities returned by functions of this service
        valueObjects.Zszh_models._initRemoteClassAlias();

        var operations:Object = new Object();
        var operation:mx.rpc.remoting.Operation;

        operation = new mx.rpc.remoting.Operation(null, "getAllZszh_models");
         operation.resultElementType = valueObjects.Zszh_models;
        operations["getAllZszh_models"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "getZszh_modelsByID");
         operation.resultType = valueObjects.Zszh_models;
        operations["getZszh_modelsByID"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "createZszh_models");
         operation.resultType = int;
        operations["createZszh_models"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "updateZszh_models");
        operations["updateZszh_models"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "deleteZszh_models");
        operations["deleteZszh_models"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "count");
         operation.resultType = int;
        operations["count"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "getZszh_models_paged");
         operation.resultElementType = valueObjects.Zszh_models;
        operations["getZszh_models_paged"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "getZszh_modelsByCategory");
         operation.resultType = Object;
        operations["getZszh_modelsByCategory"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "countByCategory");
         operation.resultType = Object;
        operations["countByCategory"] = operation;
        operation = new mx.rpc.remoting.Operation(null, "getZszh_jiancaiByClassName");
         operation.resultType = Object;
        operations["getZszh_jiancaiByClassName"] = operation;

        _serviceControl.operations = operations;
        _serviceControl.convertResultHandler = com.adobe.serializers.utility.TypeUtility.convertResultHandler;
        _serviceControl.source = "ZszhmodelsService";
        _serviceControl.endpoint = "gateway.php";
        var managedAssociation : mx.data.ManagedAssociation;
        var managedAssocsArray : Array;
        // initialize Zszh_models data manager
        _zszh_modelsRPCDataManager = new mx.data.RPCDataManager();
        managersArray.push(_zszh_modelsRPCDataManager);

        managedAssocsArray = new Array();

        _zszh_modelsRPCDataManager.destination = "zszh_modelsRPCDataManager";
        _zszh_modelsRPCDataManager.service = _serviceControl;        
        _zszh_modelsRPCDataManager.identities =  "id";      
        _zszh_modelsRPCDataManager.itemClass = valueObjects.Zszh_models; 



        var dmOperation : mx.data.ManagedOperation;
        var dmQuery : mx.data.ManagedQuery;

        dmOperation = new mx.data.ManagedOperation("getZszh_modelsByID", "get");
        dmOperation.parameters = "id";
        _zszh_modelsRPCDataManager.addManagedOperation(dmOperation);     

        dmQuery = new mx.data.ManagedQuery("getZszh_models_paged");
        dmQuery.propertySpecifier = "id,className,objectName,resourcePath,category,property,imgThumbnail";
        dmQuery.countOperation = "count";
        dmQuery.pagingEnabled = true;
        dmQuery.positionalPagingParameters = true;
        dmQuery.parameters = "startIndex,numItems";
        _zszh_modelsRPCDataManager.addManagedOperation(dmQuery);

        dmQuery = new mx.data.ManagedQuery("getAllZszh_models");
        dmQuery.propertySpecifier = "id,className,objectName,resourcePath,category,property,imgThumbnail";
        dmQuery.parameters = "";
        _zszh_modelsRPCDataManager.addManagedOperation(dmQuery);

        dmOperation = new mx.data.ManagedOperation("createZszh_models", "create");
        dmOperation.parameters = "item";
        _zszh_modelsRPCDataManager.addManagedOperation(dmOperation);     

        dmOperation = new mx.data.ManagedOperation("updateZszh_models", "update");
        dmOperation.parameters = "item";
        _zszh_modelsRPCDataManager.addManagedOperation(dmOperation);     

        dmOperation = new mx.data.ManagedOperation("deleteZszh_models", "delete");
        dmOperation.parameters = "id";
        _zszh_modelsRPCDataManager.addManagedOperation(dmOperation);     

        _serviceControl.managers = managersArray;

         preInitializeService();
         model_internal::initialize();
    }
    
    //init initialization routine here, child class to override
    protected function preInitializeService():void
    {
        destination = "ZszhmodelsService";
      
    }
    

    /**
      * This method is a generated wrapper used to call the 'getAllZszh_models' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function getAllZszh_models() : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getAllZszh_models");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send() ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'getZszh_modelsByID' operation. It returns an mx.data.ItemReference whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.data.ItemReference
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.data.ItemReference whose result property will be populated with the result of the operation when the server response is received.
      */
    public function getZszh_modelsByID(itemID:int) : mx.data.ItemReference
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getZszh_modelsByID");
		var _internal_token:mx.data.ItemReference = _internal_operation.send(itemID) as mx.data.ItemReference;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'createZszh_models' operation. It returns an mx.data.ItemReference whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.data.ItemReference
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.data.ItemReference whose result property will be populated with the result of the operation when the server response is received.
      */
    public function createZszh_models(item:valueObjects.Zszh_models) : mx.data.ItemReference
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("createZszh_models");
		var _internal_token:mx.data.ItemReference = _internal_operation.send(item) as mx.data.ItemReference;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'updateZszh_models' operation. It returns an mx.data.ItemReference whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.data.ItemReference
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.data.ItemReference whose result property will be populated with the result of the operation when the server response is received.
      */
    public function updateZszh_models(item:valueObjects.Zszh_models) : mx.data.ItemReference
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("updateZszh_models");
		var _internal_token:mx.data.ItemReference = _internal_operation.send(item) as mx.data.ItemReference;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'deleteZszh_models' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function deleteZszh_models(itemID:int) : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("deleteZszh_models");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(itemID) ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'count' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function count() : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("count");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send() ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'getZszh_models_paged' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function getZszh_models_paged() : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getZszh_models_paged");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send() ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'getZszh_modelsByCategory' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function getZszh_modelsByCategory(itemCategory:Object, startIndex:Object, numItems:Object) : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getZszh_modelsByCategory");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(itemCategory,startIndex,numItems) ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'countByCategory' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function countByCategory(itemCategory:Object) : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("countByCategory");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(itemCategory) ;
        return _internal_token;
    }
     
    /**
      * This method is a generated wrapper used to call the 'getZszh_jiancaiByClassName' operation. It returns an mx.rpc.AsyncToken whose 
      * result property will be populated with the result of the operation when the server response is received. 
      * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
      * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
      *
      * @see mx.rpc.AsyncToken
      * @see mx.rpc.CallResponder 
      *
      * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
      */
    public function getZszh_jiancaiByClassName(itemClassName:Object, startIndex:Object, numItems:Object) : mx.rpc.AsyncToken
    {
        var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getZszh_jiancaiByClassName");
		var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(itemClassName,startIndex,numItems) ;
        return _internal_token;
    }
     
}

}
