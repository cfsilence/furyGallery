var APPLICATION = { serviceURL : 'com/cfsilence/service/GalleryServiceRemote.cfc?_cf_nodebug=true' };


// our base object - which all others shall extend
var Entity = Class.extend({
	init: function(){
		this.__type__ = '';  // used for "rehydration" on the cf side
    },
	commit : function() {
		for ( var prop in this ){
			if( this.hasOwnProperty( prop ) && this[prop].hasOwnProperty('commit') && this[prop] != undefined ){
					this[prop].commit()
			}
		}
	},
	reset : function() {
		for ( var prop in this ){
			if( this.hasOwnProperty( prop ) && this[prop].hasOwnProperty('reset') && this[prop] != undefined ){
				this[prop].reset();
			}
		}
	}
});

/*
 * Model
 */

var Artist = Entity.extend({
	init : function( artistId, art, firstName, lastName, address, city, state, postalCode, email, phone, fax, thePassword ){
		this.artistId = ko.protectedObservable( artistId ) || -1;
		this.art = ko.observableArray( art );  // doth this need protection? probably not, since it's an array of entities who already are protected.
		this.firstName = ko.protectedObservable( firstName );
		this.lastName = ko.protectedObservable( lastName );
		this.address = ko.protectedObservable( address );
		this.city = ko.protectedObservable( city );
		this.state = ko.protectedObservable( state );
		this.postalCode = ko.protectedObservable( postalCode );
		this.email = ko.protectedObservable( email );
		this.phone = ko.protectedObservable( phone );
		this.fax = ko.protectedObservable( fax );
		this.thePassword = ko.protectedObservable( thePassword );
		this.fullName = ko.computed(function(){ return this.firstName() + ' ' + this.lastName(); }, this);
	}
});

var Art = Entity.extend({
	init : function( artId, artist, artName, description, price, largeImage, media, isSold ){
		this.artId = ko.protectedObservable( artId ) || -1;
		this.artist = ko.protectedObservable( artist );
		this.artName = ko.protectedObservable( artName );
		this.description = ko.protectedObservable( description );
		this.price = ko.protectedObservable( price );
		this.largeImage = ko.protectedObservable( largeImage );
		this.media = ko.protectedObservable( media );
		this.isSold = ko.protectedObservable( isSold );
	}
});

var Media = Entity.extend({
	init : function( mediaId, mediaType ){
		this.mediaId = ko.protectedObservable( mediaId ) || -1;
		this.mediaType = ko.protectedObservable( mediaType );
	}
});

/*
 * Service Delegate
 *
 * Abstracts out-of-browser dependencies.  
 */
var GalleryService = function () {
	
	var self = this;
	
    self.loadArtists = function(  ) {
        $.ajax(
			{
				url: APPLICATION.serviceURL + '&method=getArtists&returnFormat=JSON',
				success: function(data, textStatus, jqXHR){
					fury.publish( 'artists.loaded', data );
				},
				error: function(e){
					console.log(e)
				}
			}
    	);
    }
	
	self.saveArtist = function( artist ){
		$.ajax(
			{
				type: 'POST',
				url: APPLICATION.serviceURL + '&method=saveArtist&returnFormat=JSON',
				data: { artist : artist } ,
				success: function(d, textStatus, jqXHR){
					fury.publish( 'artist.saved', d );
				},
				error: function(e){
					console.log(e)
				}
			}
    	);
	}
}

var GalleryController = function(){
	fury.inject( this, "galleryPresentationModel", "pm", function() {} );
	
	/* Service injection */
    fury.inject( this, "galleryService", "service", function() { });
	
	fury.subscribe( "artist.new", this, function() {
		console.log( this.pm.artists);
		var newArtist = new Artist();
		this.pm.artists.push( newArtist );
		this.pm.selectedArtist( newArtist );
		$('#editArtContainer').modal('show');
	});
	
	fury.subscribe( "artist.cancelSave", this, function( data ) {
		// reject the changes so our model isn't dirty
		this.pm.selectedArtist().reset();
		// hide the window
		$('#editArtContainer').modal('hide');
	});
	
	fury.subscribe( "artist.saved", this, function( id ) {
		// hide the window
		this.pm.selectedArtist().artistId = id;
		$('#editArtContainer').modal('hide');
	});
	
	fury.subscribe( "artist.saveRequested", this, function( data ) {
		// todo: validate it
		
		// commit it to the model
		this.pm.selectedArtist().commit();
		
		// save it
		this.service.saveArtist( ko.toJSON( this.pm.selectedArtist() ) )
		
	});
	
	fury.subscribe( "artist.select", this, function( content ) {
		this.pm.selectedArtist(content);
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
					if (media) {
						media.__type__ = piece.media.__type__;
					}
					var art = new Art( piece.artId, piece.artist, piece.artName, piece.description, piece.price, piece.largeImage, media, piece.isSold)
					art.__type__ = piece.__type__;
					artArray.push( art );	
				}
				var localArtist = new Artist( artist.artistId, artArray, artist.firstName, artist.lastName, artist.address, artist.city, artist.state, artist.postalCode, artist.email, artist.phone, artist.fax, artist.thePassword )
				localArtist.__type__ = artist.__type__; 
				this.pm.artists.push( localArtist );
			}
        }
    });
	
	fury.subscribe( "application.start", this, function() {
		
		this.service.loadArtists()
		
		// EVENT HANDLERS
		$('.view-art-btn,.edit-art-btn').live('click', function(){
			fury.publish( 'artist.select', ko.dataFor( this ) )
		});
		
		$('.view-art-btn').live('click', function(){
			$('#artContainer').modal({});
		});
		
		$('.edit-art-btn').live('click', function(){
			$('#editArtContainer').modal({});
		});
		
		$('#newArtistBtn').click(function(){
			fury.publish( 'artist.new' );
		});
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
    // Ask fury for the PresentationModel bean and tell Knockout to watch it for changes
    ko.applyBindings( fury.bean( "galleryPresentationModel" ) );

    // Publish the "application.start" message (think dispatchEvent( eventName, data ) )
    fury.publish( "application.start" );
});
