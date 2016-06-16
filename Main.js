var Observable = require("FuseJS/Observable")
var unpacker = require("BundleUnpacker")
var initExpression = module.exports.initExpression = Observable()

/* Our quick/dirty BundleUnpacker NativeModule takes the filename of a bundled file,
extracts it to device temp storage, and returns the path to the created file.
If the file path already exists, we just return the path and don't extract. */

unpacker.unpack("Chart.bundle.min.js")
	.then( function(path) { 
			// We now know the path to our file, so we can call our html-embedded method
			initExpression.value = 'initCharts("'+path+'")';
		}
	).catch( function(e) {
		console.log("Couldn't extract bundle: "+e) } 
	)
