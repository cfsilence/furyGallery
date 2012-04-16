<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>
			Fury Art Gallery
		</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="description" content="">
		<meta name="author" content="">
		
		<!-- Le styles -->
		<link href="bootstrap/css/bootstrap.css" rel="stylesheet">
		<link href="includes/css/styles.css" rel="stylesheet">
		<style>
			body {
			    padding-top: 60px; /* 60px to make the container go all the way to the bottom of the topbar */
			}
		</style>
		<link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
		
		<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
						<!--[if lt IE 9]>
		<script src="//html5shim.googlecode.com/svn/trunk/html5.js">

		</script>
		<![endif]-->
		<link rel="shortcut icon" href="images/favicon.ico">
		<link rel="apple-touch-icon" href="images/apple-touch-icon.png">
		<link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
		<link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
	</head>
	
	<body>
	
		<div class="navbar navbar-fixed-top">
			<div class="navbar-inner">
				<div class="container">
					<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
						<span class="icon-bar">
						</span>
						<span class="icon-bar">
						</span>
						<span class="icon-bar">
						</span>
					</a>
					<a class="brand" href="#">Fury Art Gallery</a>
					<!--/.nav-collapse -->
				</div>
			</div>
		</div>
		
		<div class="container">
		
			<div class="row">
			
				<div id="artistsContainer" class="span12">
				
					<h2>
						Fury Artists
					</h2>
					
					<table class="table table-striped table-bordered">
						<thead>
							<tr>
								<th>
									First name
								</th>
								<th>
									Last name
								</th>
								<th>
									City
								</th>
								<th>
									State
								</th>
								<th>
									Action
								</th>
							</tr>
						</thead>
						<tbody data-bind="foreach: artists">
							<tr>
								<td data-bind="text: firstName">
								</td>
								<td data-bind="text: lastName">
								</td>
								<td data-bind="text: city">
								</td>
								<td data-bind="text: state">
								</td>
								<td>
									<a class="btn btn-info edit-art-btn">
										Edit Artist
									</a>
									<a class="btn btn-info view-art-btn" href="#">View Art</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			
			<div id="editArtContainer" class="modal hide fade">
				<div class="modal-header">
					<a class="close" data-dismiss="modal">
						&times;
					</a>
					<h2>
						Edit Artist
					</h2>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<fieldset>
							<legend></legend>
							<div class="control-group">
								<label class="control-label" for="firstName">
									First Name
								</label>
								<div class="controls">
									<input type="text" class="input-xlarge" data-bind="value: selectedArtist() ? selectedArtist().firstName : null" id="firstName">
									<p class="help-block">
										The given first name of this artist.  
									</p>
									
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="lastName">
									Last Name
								</label>
								<div class="controls">
									<input type="text" class="input-xlarge" data-bind="value: selectedArtist() ? selectedArtist().lastName : null" id="lastName">
									<p class="help-block">
										The surname of said artist. 
									</p>
									
								</div>
							</div>
						</fieldset>
					</form>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn btn-danger" data-bind="click: function(data, event) { fury.publish( 'artist.cancelSave', { data : data, event : event } ) }">Cancel</a>
					<a href="#" class="btn btn-primary" data-bind="click: function(data, event) { fury.publish( 'artist.saveRequested', { data : data, event : event } ) }">Save</a>
				</div>
			</div>
			
			<div id="artContainer" class="modal hide fade">
				<div class="modal-header">
					<a class="close" data-dismiss="modal">
						&times;
					</a>
					<h2>
						Art by 
						<span data-bind="text: selectedArtist() ? selectedArtist().fullName : null">
						</span>
					</h2>
				</div>
				<div class="modal-body">
					<table class="table table-striped table-bordered">
						<thead>
							<tr>
								<th>
									Piece
								</th>
								<th>
									Description
								</th>
								<th>
									Price
								</th>
								<th>
									Media
								</th>
							</tr>
						</thead>
						<tbody data-bind="foreach: selectedArtist() ? selectedArtist().art : null">
							<tr>
								<td data-bind="text: artName">
								</td>
								<td data-bind="text: description">
								</td>
								<td data-bind="text: price">
								</td>
								<td data-bind="text: media() ? media().mediaType : null">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<a href="#" class="btn" data-dismiss="modal">Close</a>
				</div>
			</div>
		</div>
		<!-- /container -->
		<script src="includes/js/js-inheritance.js">

		</script>
		<script src="includes/js/amplify.store.min.js">

		</script>
		<script src="includes/js/fury-0.0.0.js">

		</script>
		<script src="includes/js/jquery-1.7.1.min.js">

		</script>
		<script src="includes/js/json2.js">

		</script>
		<script src="includes/js/knockout-2.0.0.js">

		</script>
		<script src="includes/js/knockout-addons.js">

		</script>
		<script src="includes/js/gallery-fury.js">

		</script>
		
		<script src="bootstrap/js/bootstrap-transition.js">

		</script>
		<script src="bootstrap/js/bootstrap-alert.js">

		</script>
		<script src="bootstrap/js/bootstrap-modal.js">

		</script>
		<script src="bootstrap/js/bootstrap-dropdown.js">

		</script>
		<script src="bootstrap/js/bootstrap-scrollspy.js">

		</script>
		<script src="bootstrap/js/bootstrap-tab.js">

		</script>
		<script src="bootstrap/js/bootstrap-tooltip.js">

		</script>
		<script src="bootstrap/js/bootstrap-popover.js">

		</script>
		<script src="bootstrap/js/bootstrap-button.js">

		</script>
		<script src="bootstrap/js/bootstrap-collapse.js">

		</script>
		<script src="bootstrap/js/bootstrap-carousel.js">

		</script>
		<script src="bootstrap/js/bootstrap-typeahead.js">

		</script>
	</body>
</html>