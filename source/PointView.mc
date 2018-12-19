//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Math;

// Main view for the application
class PointView extends Ui.View {
    var _distanceUnit = "m";
    var _geoMock = "X XX° XX' XX.XX''";
    var _orientation;
    var _longitude;
    var _latitude;
    var _altitude;

    // Constructor
    function initialize() {
        _orientation = "X";
        _longitude = _geoMock;
        _latitude = _geoMock;
        _altitude = "XXXX";

        initializeLocationListener();
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.Main(dc));
        bindData();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    function onPosition( info ) {
        _orientation = getOrientation(info.heading);
        _longitude = getLogitude( info.position.toGeoString( Position.GEO_DEG ) );
        _latitude = getLatitude( info.position.toGeoString( Position.GEO_DEG ) );
        _altitude = getAltitude( info.altitude );

        bindData();
    }   

    function initializeLocationListener() {
        Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method( :onPosition ) );
    }

    function bindData() {
        var view = View.findDrawableById("Orientation");
        view.setText(_orientation);
        view = View.findDrawableById("Longitude");
        view.setText(_longitude);
        view = View.findDrawableById("Latitude");
        view.setText(_latitude);
        view = View.findDrawableById("Altitude");
        view.setText(_altitude + "" + _distanceUnit);
        
        Ui.requestUpdate();
    }

    function getLogitude(geo) {
         if (geo == null || geo.length() < 23) {
            return _geoMock;
        }
        var lo = geo.substring(0, 11);
        return parseGeo(lo);
    }

     function getLatitude(geo) {
         if (geo == null || geo.length() < 23) {
            return _geoMock;
        }
        var la = geo.substring(12, 23);
        return parseGeo(la);
    }

    function getAltitude(alt) {
        var i = alt.toString().find(".");
        return Math.round(alt).toString().substring(0,i);
    }

    function getOrientation(heading) {
        var o = "X";

        if (heading <= 0.523598 && heading > -0.523598) {
            o = "N";
        } else if (heading > 0.523598 && heading <= 1.047197) {
            o = "NE";
        } else if (heading >= 1.047197 && heading < 2.094395) {
            o = "E";
        } else if (heading >= 2.094395 && heading < 2.617993) {
            o = "SE";
        } else if (heading >= -2.617993 && heading < -2.094395) {
            o = "SW";
        } else if (heading >= -2.094395 && heading < -1.047197) {
            o = "W";
        } else if (heading >= -1.047197 && heading < -0.523598) {
            o = "NW";
        } else {
            o = "S";
        }

        return o;
    }

    function parseGeo(raw) {
        if (raw == null || raw.length() < 11) {
            return _geoMock;
        }

        var o = raw.substring(0,1);
        var d = raw.substring(1,4);
        var m = raw.substring(5,7);
        var s1 = raw.substring(7,9);
        var s2 = raw.substring(9,11);

        return o + " " + d + "° " + m + "' " + s1 + "." + s2 + "''";
    }

}
