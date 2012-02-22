component 
{
	this.name = 'furyTest';
	this.datasource = 'cfartgallery';
	this.ormEnabled = true;
	this.ormSettings = { dbcreate='none', logsql=true };
	this.mappings['/com'] = getDirectoryFromPath( getCurrentTemplatePath() ) & "com";
	
	public function onApplicationStart(){
		
	}
	
	public function onRequestStart(){
		
		if( structKeyExists( url, 'reinit' ) ){
			ormReload();
		}
		
	}
	
}