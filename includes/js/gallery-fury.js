var serviceURL = 'com/cfsilence/service/TestServiceRemote.cfc?_cf_nodebug=true';

/*
 * Model
 */

var Artist = function( artistId, art, firstName, lastName, address, city, state, postalCode, email, phone, fax, thePassword ){
	this.artistId = ko.observable( artistId );
	this.art = ko.observableArray( art );
	this.firstName = ko.observable( firstName );
	this.lastName = ko.observable( lastName );
	this.address = ko.observable( address );
	this.city = ko.observable( city );
	this.state = ko.observable( state );
	this.postalCode = ko.observable( postalCode );
	this.email = ko.observable( email );
	this.phone = ko.observable( phone );
	this.fax = ko.observable( fax );
	this.thePassword = ko.observable( thePassword );
	this.fullName = ko.computed(function(){ return this.firstName() + ' ' + this.lastName(); }, this);
};

var Art = function( artId, artist, artName, description, price, largeImage, media, isSold ){
	this.artId = ko.observable( artId );
	this.artist = ko.observable( artist );
	this.artName = ko.observable( artName );
	this.description = ko.observable( description );
	this.price = ko.observable( price );
	this.largeImage = ko.observable( largeImage );
	this.media = ko.observable( media );
	this.isSold = ko.observable( isSold );
}

var Media = function( mediaId, mediaType ){
	this.mediaId = ko.observable( mediaId );
	this.mediaType = ko.observable( mediaType );
};

/*
 * Service Delegate
 *
 * Abstracts out-of-browser dependencies.  In this case,
 * we're hiding the fact that we use the Amplify framework for easy local storage.
 */
var GalleryService = function () {
    this.loadArtists = function(  ) {
        $.ajax(
			{
				url: serviceURL + '&method=getArtists&returnFormat=JSON',
				success: function(data, textStatus, jqXHR){
					fury.publish( 'artists.loaded', data );
				},
				error: function(e){
					console.log(e)
				}
			}
    	);
    }
}

var GalleryController = function(){
	fury.inject( this, "galleryPresentationModel", "pm", function() { 
	} );
	
	/* Service injection */
    fury.inject( this, "galleryService", "service", function() { });
	
	fury.subscribe( "artist.select", this, function( content ) {
		this.pm.selectedArtist(content);
		this.pm.showArtist(true);
	});
	
	fury.subscribe( "artists.loaded", this, function( content ) {
        if ( content.length ) {
			var result = JSON.parse( content );
			var artists = [];
			
			for( idx in result){
				var artArray = [];
				var artist = result[ idx ];
				
				for ( pieceIdx in artist.art ){
					var piece = artist.art[ pieceIdx ];
					var media = piece.media ? new Media( piece.media.mediaId, piece.media.mediaType ) : null;
					var art = new Art( piece.artId, piece.artist, piece.artName, piece.description, piece.price, piece.largeImage, media, piece.isSold)
					artArray.push( art );	
				}
				var localArtist = new Artist( artist.artistId, artArray, artist.firstName, artist.lastName, artist.address, artist.city, artist.state, artist.postalCode, artist.email, artist.phone, artist.fax, artist.thePassword )
				this.pm.artists.push( localArtist );
			}
        }
    });
	
	fury.subscribe( "application.start", this, function() {
		this.service.loadArtists()
    });
};

var GalleryPresentationModel = function() {
    var self = this;

    // DEPENDENCIES


    // PROPERTIES

    /*
     * "Bindable" properties representing the state of our view.  Their
     * names should be descriptive enough to say what they do.
     */
    self.artists = ko.observableArray([]);
	self.selectedArtist = ko.observable();
	self.showArtist = ko.observable(false)
	
	self.initialize = function () {
        // Whenever Knockout sees a change to this model, call update()
        ko.computed( self.update );
    }
	
    // METHODS
	
};

fury.register({
    galleryPresentationModel : new GalleryPresentationModel(),
    galleryController : new GalleryController(),
    galleryService : new GalleryService()
})


$(document).ready(function(){
	console.log('ready')
    // Ask fury for the todoPresentationModel bean and tell Knockout to watch it for changes
    ko.applyBindings( fury.bean( "galleryPresentationModel" ) );

    // Publish the "application.start" message (think dispatchEvent( eventName, data ) )
    fury.publish( "application.start" );
});
