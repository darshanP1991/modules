class wordpress{
exec {"apt update" :
	path=>['/usr/bin','/usr/sbin',]
}

$packagenames = ['apache2', 'mysql-server', 'mysql-client', 'php', 'libapache2-mod-php', 'php-mcrypt', 'php-mysql' , 'unzip']  
$packagenames.each |String $package| { 
package {"${package}":     
	ensure => latest,   } 
}

service {"apache2" :
	ensure=>running
}  

user {"mysqladmin" :
	ensure=>present,
	password => Sensitive("rootpassword")
}

exec {"wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands" :       
	cwd=>'/tmp/',       
	path=>['/usr/bin']
} 

exec {"wget https://wordpress.org/latest.zip" :
	cwd=>'/tmp/',
	path=>['/usr/bin']
}


exec {"unzip /tmp/latest.zip -d /var/www/html" :        
	path=>'/usr/bin',
	creates => '/var/www/html/wordpress'
} 

file {'/var/www/html/wordpress/wp-config-sample.php':    
	ensure => absent
 }

exec {"wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php" :        
	cwd=>'/var/www/html/wordpress/',        
	path=>['/usr/bin']
}

file {'/var/www/html/wordpress/wp-config.php':    
	ensure => present,    
	source => '/var/www/html/wordpress/wp-config-sample.php' 
}

file {"/var/www/html/wordpress" :        
	recurse=>true,       
	owner=>'www-data',       
	group=>'www-data',       
	mode=>'775'
}  

exec {"service apache2 restart" : 
	path => ['/usr/sbin', '/usr/bin', '/bin', '/sbin'] }
}
