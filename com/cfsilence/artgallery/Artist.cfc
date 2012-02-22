component persistent='true' table='artists' entityname='Artist' accessors='true'
{
	property name='artistId' type='numeric' generator='increment' assemble='true';
	property name='art' fieldtype='one-to-many' inverse='true' cfc='com.cfsilence.artgallery.Art' lazy='false' fkcolumn='artistId' assemble='true';
	property name='firstName' type='string' assemble='true';
	property name='lastName' type='string' assemble='true'; 
	property name='address' type='string' assemble='true';
	property name='city' type='string' assemble='true';
	property name='state' type='string' assemble='true';
	property name='postalCode' type='string' assemble='true';
	property name='email' type='string' assemble='true';
	property name='phone' type='string' assemble='true';
	property name='fax' type='string' assemble='true';
	property name='thePassword' type='string' assemble='true';
}