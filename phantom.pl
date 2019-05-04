policy('Policy_phantom','File Management', [
	/** Define the users */
		user('cheptsov@hlrs.de'),
		user('hpcjmont@hlrs.de'),
		user('gienger@hlrs.de'),
		user('hpcbasti@hlrs.de'),
		user('bourgos@wings-ict-solutions.eu'),
		user('gtzanettis@wings-ict-solutions.eu'),
		user('ian.gray@york.ac.uk'),
		user('neil.audsley@cs.york.ac.uk'),
		user('r.delong@opengroup.org'),
		user('s.hansen@opengroup.org'),
		user('andre.rocha@gmv.com'),
		user('jose.neves@gmv.com'),
		user('marcio.mateus@unparallel.pt'),
		user('bruno.almeida@unparallel.pt'),
		user('wenbin.li@eglobalmark.com'),
		user('franck.le-gall@eglobalmark.com'),
		user('philippe.cousin@eglobalmark.com'),
		user('pierluigi.pierini@intecs.it'),
		user('silvia.mazzini@intecs.it'),
	/** gmv policy */
			user('satellite@gmv.com'), 		% producer of the image and related info
			user('geo_entity@gmv.com'), 	% producer of earth geographic info
			user('simons_exec@gmv.com'), 	% program that will access the available data
			user('legit_user@gmv.com'), 	% legit user of the application
			user('programmer@gmv.com'), 	% user that develops the application
			user('intruder@gmv.com'), 		% menace
			user('fmpereira@gmv.com'),

	/** Define the type of objects in the repository*/
	/** First the basic default domain, where everybody has read and write permissions*/
		object('domain_public'),
	/** Second, the private domains, where only users in their group can read and write */
		object('domain_hlrs'),
		object('domain_wings'),
		object('domain_york'),
		object('domain_opengroup'),
		object('domain_gmv'),
		object('domain_unparallel'),
		object('domain_eglobalmark'),
		object('domain_intecs'),
	/** Third, the shared domains, where only users in their group can write, but everybody else can read */
		object('shared_hlrs'),
		object('shared_wings'),
		object('shared_york'),
		object('shared_opengroup'),
		object('shared_gmv'),
		object('shared_unparallel'),
		object('shared_eglobalmark'),
		object('shared_intecs'),
	/** gmv objects*/
			object('input_image'),
			object('coastline'),
			object('output_image'),
			object('source_code'),
			object('config_files'),
			object('scripts'),
			object('description_files'),
			object('security_policy'),
			object('Input_Data'),
			object('Output_Data'),
			object('App_Data'),

	/** Assign to the users to global set */
		user_attribute('Users'),
		user_attribute('Users_hlrs'),
		user_attribute('Users_wings'),
		user_attribute('Users_york'),
		user_attribute('Users_opengroup'),
		user_attribute('Users_gmv'),
		user_attribute('Users_unparallel'),
		user_attribute('Users_eglobalmark'),
		user_attribute('Users_intecs'),
	/** gmv attributes */
			user_attribute('Input_producer'), 	% able to write any input file
			user_attribute('Output_producer'),	% able to write any output file
			user_attribute('Input_Consumer'), 	% able to read any input file
			user_attribute('Output_Consumer'), 	% able to read any output file
			user_attribute('Developer'), 		% able to read and write any application file

	/** Assign to the users to groups */
		assign('cheptsov@hlrs.de','Users_hlrs'),
		assign('hpcjmont@hlrs.de','Users_hlrs'),
		assign('gienger@hlrs.de','Users_hlrs'),
		assign('hpcbasti@hlrs.de','Users_hlrs'),

		assign('bourgos@wings-ict-solutions.eu','Users_wings'),
		assign('gtzanettis@wings-ict-solutions.eu','Users_wings'),

		assign('ian.gray@york.ac.uk','Users_york'),
		assign('neil.audsley@cs.york.ac.uk','Users_york'),

		assign('r.delong@opengroup.org','Users_opengroup'),
		assign('s.hansen@opengroup.org','Users_opengroup'),

		assign('andre.rocha@gmv.com','Users_gmv'),
		assign('jose.neves@gmv.com','Users_gmv'),

		assign('marcio.mateus@unparallel.pt','Users_unparallel'),
		assign('bruno.almeida@unparallel.pt','Users_unparallel'),

		assign('wenbin.li@eglobalmark.com','Users_eglobalmark'),
		assign('franck.le-gall@eglobalmark.com','Users_eglobalmark'),
		assign('philippe.cousin@eglobalmark.com','Users_eglobalmark'),

		assign('pierluigi.pierini@intecs.it','Users_intecs'),
		assign('silvia.mazzini@intecs.it','Users_intecs'),

	/** groups */
		assign('Users_hlrs','Users'),
		assign('Users_wings','Users'),
		assign('Users_york','Users'),
		assign('Users_opengroup','Users'),
		assign('Users_gmv','Users'),
		assign('Users_unparallel','Users'),
		assign('Users_eglobalmark','Users'),
		assign('Users_intecs','Users'),
	/** Assign all the variables to the class 'File Management', needed by the tool*/
		policy_class('File Management'),
		connector('PM'),
		assign('Users','File Management'),
		assign('domain_public','File Management'),
		assign('domain_hlrs','File Management'),
		assign('domain_wings','File Management'),
		assign('domain_york','File Management'),
		assign('domain_opengroup','File Management'),
		assign('domain_gmv','File Management'),
		assign('domain_unparallel','File Management'),
		assign('domain_eglobalmark','File Management'),
		assign('domain_intecs','File Management'),
	/** define-add the permissions of each group on each type of object */
		operation(r,'File'),
		operation(w,'File'),
	/** First the basic default domain, where everybody has read and write permissions*/
		associate('Users',[r,w],'domain_public'),
	/** Second, the private domains, where only users in their group can read and write */
		associate('Users_hlrs',[r,w],'domain_hlrs'),
		associate('Users_wings',[r,w],'domain_wings'),
		associate('Users_york',[r,w],'domain_york'),
		associate('Users_opengroup',[r,w],'domain_opengroup'),
		associate('Users_gmv',[r,w],'domain_gmv'),
		associate('Users_unparallel',[r,w],'domain_unparallel'),
		associate('Users_eglobalmark',[r,w],'domain_eglobalmark'),
		associate('Users_intecs',[r,w],'domain_intecs'),
	/** Third, the shared domains, where only users in their group can write, but everybody else can read */
		associate('Users',[r],'shared_hlrs'),
		associate('Users',[r],'shared_wings'),
		associate('Users',[r],'shared_york'),
		associate('Users',[r],'shared_opengroup'),
		associate('Users',[r],'shared_gmv'),
		associate('Users',[r],'shared_unparallel'),
		associate('Users',[r],'shared_eglobalmark'),
		associate('Users',[r],'shared_intecs'),
	/** now the owners*/
		associate('Users_hlrs',[r,w],'shared_hlrs'),
		associate('Users_wings',[r,w],'shared_wings'),
		associate('Users_york',[r,w],'shared_york'),
		associate('Users_opengroup',[r,w],'shared_opengroup'),
		associate('Users_gmv',[r,w],'shared_gmv'),
		associate('Users_unparallel',[r,w],'shared_unparallel'),
		associate('Users_eglobalmark',[r,w],'shared_eglobalmark'),
		associate('Users_intecs',[r,w],'shared_intecs'),
	/** gmv assigments */
			/**% list of relations of users*/
			assign('satellite@gmv.com', 'Input_Producer'),
			assign('geo_entity@gmv.com', 'Input_Producer'),
			assign('simons_exec@gmv.com', 'Output_Producer'),
			assign('simons_exec@gmv.com', 'Input_Consumer'),
			assign('andre.rocha@gmv.com', 'Input_Consumer'),
			assign('fmpereira@gmv.com', 'Input_Consumer'),
			assign('legit_user@gmv.com', 'Output_Consumer'),
			assign('programmer@gmv.com', 'Developer'),
			assign('bourgos@wings-ict-solutions.eu', 'Developer'),
			assign('gtzanettis@wings-ict-solutions.eu', 'Developer'),
			assign('r.delong@opengroup.org', 'Developer'),
			assign('andre.rocha@gmv.com', 'Developer'),
			assign('fmpereira@gmv.com', 'Developer'),
			assign('hpcjmont@hlrs.de', 'Developer'),
			assign('Input_Producer', 'Users'),
			assign('Output_Producer', 'Users'),
			assign('Input_Consumer', 'Users'),
			assign('Output_Consumer', 'Users'),
			assign('Developer', 'Users'),
			assign('intruder@gmv.com', 'Users'),

			/**% list of relations of objects*/
			assign('input_image', 'Input_Data'),
			assign('coastline', 'Input_Data'),
			assign('output_image', 'Output_Data'),
			assign('source_code', 'App_Data'),
			assign('config_files', 'App_Data'),
			assign('scripts', 'App_Data'),
			assign('description_files', 'App_Data'),
			assign('security_policy', 'App_Data'),

			/**	% other relations*/
			assign('Users', 'File Management'),
			assign('Input_Data', 'File Management'),
			assign('Output_Data', 'File Management'),
			assign('App_Data', 'File Management'),

	/**	% access policies*/
		associate('Input_Producer', [w], 'Input_Data'),
		associate('Output_Producer', [w], 'Output_Data'),
		associate('Input_Consumer', [r], 'Input_Data'),
		associate('Output_Consumer', [r], 'Output_Data'),
		associate('Developer', [r, w], 'App_Data')
	]).
