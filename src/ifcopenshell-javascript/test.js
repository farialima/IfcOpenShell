var chai = require('chai');
var assert = chai.assert;
var expect = chai.expect;

var ifcopenshell = require("../../build/Darwin/x86_64/build/ifcopenshell/javascript/ifcopenshell-ifcjavacript/ifcopenshell_wrapper")

var ifc = ifcopenshell.open('miniExample20080731_CoordView_SweptSolid.ifc');

describe('basic', function() {
    it('can load a file and return basic information about it', function() {
        assert.ok(ifc.entityById(1));
        assert.ok(ifc.entityById(163));
        assert.equal(ifc.FreshId(), 164, 'freshId is last Id plus 1');
        expect(function () { ifc.entityById(164) }).to.throw('Entity not found')
        // probably should have better error handling
        expect(function () { ifc.entityById(null) })
            .to.throw('in method \'IfcFile_entityById\', argument 2 of type \'int\'')
        expect(function () { ifc.entityById("1") })
            .to.throw('in method \'IfcFile_entityById\', argument 2 of type \'int\'')
  });
});

var getKeys = function(obj){
    var keys = [];
    for(var key in obj){
        keys.push(key);
    }
    return keys;
}

var getAttributeNamesArray = function(a) {
    var keys = [];
    for (i = 0; i < a.size(); i++) {    
        keys.push(a.get(i));
    }
    return keys;
}

describe('entities', function() {
    o = ifc.by_id(8);
    it('can access entities info', function() {
        oo = ifc.entityById(163);
        assert.deepEqual(getKeys(oo), [ 'equals', 'getCPtr' ]);
        expect(function () { oo.getAttributeNames() })
            .to.throw('oo.getAttributeNames is not a function');

        assert.deepEqual(getKeys(o), [
            "equals", "getCPtr", "is", "objectType", "is_a", "id", 
            "getArgumentCount", "getArgumentType", "getArgumentEntity", 
            "getArgument", "getArgumentName", "getArgumentIndex", 
            "getArgumentOptionality", "get_inverse", "getAttributeNames", 
            "getInverseAttributeNames", "setArgumentAsNull", "setArgumentAsInt", 
            "setArgumentAsBool", "setArgumentAsDouble", "setArgumentAsString", 
            "setArgumentAsEntityInstance", "setArgumentAsAggregateOfInt", 
            "setArgumentAsAggregateOfDouble", "setArgumentAsAggregateOfString", 
            "setArgumentAsAggregateOfEntityInstance", 
            "setArgumentAsAggregateOfAggregateOfInt", 
            "setArgumentAsAggregateOfAggregateOfDouble", 
            "setArgumentAsAggregateOfAggregateOfEntityInstance", "toString", 
            "is_valid"]); 
        assert.deepEqual(o.getAttributeNames().constructor.name, '_exports_StringVector'); 
        assert.deepEqual(getAttributeNamesArray(o.getAttributeNames()), [ 
            "Dimensions", "UnitType", "Prefix", "Name", ]);
    });
    
    it('can access entities types', function() {
        assert.equal(o.is_a(), 'IfcSIUnit');
        assert.equal(o.is_a('IfcSIUnit'), true);
        assert.equal(o.is_a('IfcNamedUnit'), true);
        assert.equal(o.is_a('IfcApplication'), false);
    });
    
    it('can access entity values', function() {
        v = o.getArgument(0);
        assert.deepEqual(getKeys(v), [
            "equals", "getCPtr", "intValue", "stringValue", "isNull", "size", "objectType", "toString"]);
        assert.equal(v.objectType(), 1);
        assert.equal(v.toString(), '*');
        assert.equal(v.size(), 1);
        assert.equal(v.isNull(), false);
    });

    it('can read string entity value', function() {
        v = o.getArgument(3);
        assert.equal(v.objectType(), 7);
        assert.equal(v.stringValue(), "METRE");
        expect(function () { v.intValue() })
            .to.throw('Token .METRE. at 877 invalid integer');
    });
});