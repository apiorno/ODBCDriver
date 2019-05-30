# ODBCDriver

ODBC Driver for Pharo migrated from [PharoExtras][] and Update to work fine on Phar 7.

## Instructions
  
  -Open a Playground and evaluate:

```smalltalk
	Metacello new
		baseline: 'ODBC';
		githubUser: 'apiorno'
			project: 'ODBCDriver'
			commitish: 'release-candidate'
			path: 'source';
		load
```

[pharoextras]: http://smalltalkhub.com/#!/~PharoExtras/ODBC/

