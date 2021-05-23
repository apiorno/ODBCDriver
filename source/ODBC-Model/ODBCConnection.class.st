"
A connection via ODBC
"
Class {
	#name : #ODBCConnection,
	#superclass : #Object,
	#instVars : [
		'hEnv',
		'hdbc',
		'connected',
		'dsn',
		'user',
		'password',
		'version',
		'features',
		'statements',
		'openTransaction',
		'asyncStatements'
	],
	#classVars : [
		'Registry'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC-Model-Core'
}

{ #category : #housekeeping }
ODBCConnection class >> cleanAll [
	"try to clean all connections"
	self log: 'clossing all connections'.
	self closeAll.
	self log: 'finalizating connections'.
	self registry finalizeValues.
	self log: 'running GC'.
	Smalltalk garbageCollect.
	""
	self log: self name , ' ' , ODBCConnection allInstances size asString , ' instances alive!'
]

{ #category : #housekeeping }
ODBCConnection class >> closeAll [
	"close all open connections"
	ODBCConnection allInstances
		do: [:each | each close].
self registry finalizeValues
]

{ #category : #'instance creation' }
ODBCConnection class >> dsn: dsnString user: userString password: passwordString [ 
	"creates a new instance of the receiver and open the connection"
	| instance |
	instance := self new
				initializeDsn: dsnString
				user: userString
				password: passwordString.
	[instance open] on: ODBCWarning do: [:e | e resume ].
	^ instance
]

{ #category : #samples }
ODBCConnection class >> dsn: dsnString user: userString password: passwordString query: queryString [ 
	"execute a query and show some statistics information"
	| connection statement resultSet columns rowCount iterationTime timePerRow |
	self log: 'Connecting to: ' , dsnString.
	connection := ODBCConnection
				dsn: dsnString
				user: userString
				password: passwordString.
	""
	self log: 'Creating statement for query: ' , queryString.
	statement := connection query: queryString.
	""
	self log: 'Executing statement'.
	resultSet := statement execute.
	columns := resultSet columns.
	""
	self log: 'Statement executed '.
	columns
		do: [:column | self log: '    ' , column asString].
	""
	self log: 'Iterating ResulSet'.
	rowCount := 0.
	iterationTime := Time
				millisecondsToRun: [resultSet
						do: [:row | rowCount := rowCount + 1]].
	timePerRow := (iterationTime / rowCount ) asFloat roundTo: 0.01.
	""
	self log: 'Iterating ResulSet has ' , rowCount asString , ' rows and was iterated in ' , iterationTime asString , 'ms  (' , timePerRow asString , 'ms/row)'.
	connection close
]

{ #category : #'class initialization' }
ODBCConnection class >> initialize [
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self
]

{ #category : #samples }
ODBCConnection class >> log: anObject [ 
	"private - log a message"
	| logMessage |
	logMessage := String new writeStream.
	logMessage nextPutAll: Date today asString;
		 nextPutAll: ' ';
		 nextPutAll: Time now asString;
		 nextPutAll: ': ';
		 nextPutAll: anObject asString.
	Transcript show: logMessage contents;
		 cr
]

{ #category : #'instance creation' }
ODBCConnection class >> new [
	"creates a new instance of the receiver"

	^ super new initialize.
]

{ #category : #registry }
ODBCConnection class >> register: anObject [ 
	self registry add: anObject
]

{ #category : #registry }
ODBCConnection class >> registry [
	^ Registry ifNil: [Registry := WeakRegistry new]

]

{ #category : #snapshots }
ODBCConnection class >> shutDown [
	super shutDown.
	self allSubInstances
		do: [:each | each shutDown]
]

{ #category : #snapshots }
ODBCConnection class >> startUp [
	super startUp.
	self allSubInstances
		do: [:each | each startUp]
]

{ #category : #'instance creation' }
ODBCConnection class >> toSqlServer: serverString database: dbString applicationId: appString workstationId: wsidString user: userString password: passwordString [

	| connectString |
	connectString := 'Driver={SQL Server};Server=', serverString, ';Database=', dbString, ';App=', appString, ';Wsid=', wsidString.

	^ self
		dsn: connectString
		user: userString
		password: passwordString


]

{ #category : #'instance creation' }
ODBCConnection class >> toSqlServer: serverString database: dbString user: userString password: passwordString [

	^ self
		toSqlServer: serverString
		database: dbString
		applicationId: SystemVersion current version
		workstationId: self workstationId
		user: userString
		password: passwordString


]

{ #category : #registry }
ODBCConnection class >> unregister: anObject [ 
	self registry
		remove: anObject
		ifAbsent: []
]

{ #category : #'instance creation' }
ODBCConnection class >> workstationId [

	^ Utilities authorNamePerSe, '@', NetNameResolver localHostName
]

{ #category : #private }
ODBCConnection >> addStatement: aStatement [ 
	"private - add aStatement to the statements collection"
	^ statements add: aStatement
]

{ #category : #accessing }
ODBCConnection >> asyncStatements [
	"Indicates whether the connection should use async statements or not"
	^asyncStatements
]

{ #category : #accessing }
ODBCConnection >> asyncStatements: aBool [
	"Indicates whether the connection should use async statements or not"
	asyncStatements := aBool
]

{ #category : #transactions }
ODBCConnection >> autoCommit [
	"answer if the receiver is in autoCommit mode"
	self checkConnected.
	^ (self sqlGetConnectAttr: SQLATTRAUTOCOMMIT) = SQLAUTOCOMMITON
]

{ #category : #transactions }
ODBCConnection >> autoCommit: aBoolean [ 
	"setthe receiver's auto commit option"
	self checkConnected.
	self sqlSetConnectAttr: SQLATTRAUTOCOMMIT
		value: (aBoolean
				ifTrue: [SQLAUTOCOMMITON]
				ifFalse: [SQLAUTOCOMMITOFF])
]

{ #category : #transactions }
ODBCConnection >> beginTransaction [
	"create a transaction.  set the auto commit option on if necessary"
	self checkConnected.
	openTransaction
		ifTrue: [^ self error: 'a transaction is opened!'].
	openTransaction := true.
	self ensureAutoCommitOff
]

{ #category : #private }
ODBCConnection >> checkConnected [
	"private - check if the recevier is connected"
	self isConnected
		ifFalse: [^ self error: 'unconnected!']
]

{ #category : #connecting }
ODBCConnection >> checkFeatures [
	"Check for the available features of the driver"
	| resp |
	features := IdentityDictionary new.
	#(	"Constant	Name"
		(10002		describeParam)
	) do:[:spec|
		resp := self sqlGetInfoString: spec first.
		Transcript cr; show: 'ODBC ',spec second,': ', resp.
		features at: spec second put: ('Y' = resp asUppercase).
	].
	resp := self sqlGetInfoString: 14 "SQL_SEARCH_PATTERN_ESCAPE".
	Transcript cr; show: 'ODBC Search escape: ', resp.
	features at: #searchEscape put: resp.

]

{ #category : #private }
ODBCConnection >> checkNotConnected [
	"private - check if the recevier is not connected"
	self isConnected
		ifTrue: [^ self error: 'connected!']
]

{ #category : #'private - errors' }
ODBCConnection >> checkSQLReturn: sqlReturn [ 
	"private - check the sqlReturn and generates an exception if corresponds"
	self
		checkSQLReturn: sqlReturn
		environment: hEnv
		connection: hdbc
		statement: nil
]

{ #category : #'private - errors' }
ODBCConnection >> checkSQLReturn: sqlReturn environment: anEnvironmentHandle connection: aConnectionHandle statement: aStatementHandle [ 
	"private - check the sqlReturn and generates an exception if corresponds"
	(sqlReturn == SQLSUCCESS or: [ sqlReturn == SQLSUCCESSWITHINFO ])
		ifFalse: [""
			self
				getErrorSQLReturn: sqlReturn
				environment: anEnvironmentHandle
				connection: aConnectionHandle
				statement: aStatementHandle]
]

{ #category : #'private - errors' }
ODBCConnection >> checkSQLReturn: sqlReturn statement: aStatementHandle [
	"private - check the sqlReturn and generates an exception if corresponds"
	self
		checkSQLReturn: sqlReturn
		environment: hEnv
		connection: hdbc
		statement: aStatementHandle
]

{ #category : #connecting }
ODBCConnection >> close [
	"close the receiver and all the children"
	self isConnected ifFalse: [
		self log: 'disconnected!'.
		^ self].
	statements do: [:each | each close].
	openTransaction ifTrue: [self rollbackTransaction].
	hdbc ifNotNil: [
		self sqlDisconnect: hdbc.
		self sqlFreeConnect: hdbc.
		hdbc := nil].
	hEnv ifNotNil: [
		self sqlFreeEnv: hEnv.
		hEnv := nil].
	self unregisterForFinalization.
	connected := false.
]

{ #category : #connecting }
ODBCConnection >> closeNotFail [
	"close the receiver without signaling errors"
	self isConnected
		ifFalse: [^ self].
	statements do: [:each | each closeNotFail].
	openTransaction ifTrue: [self rollbackTransaction].
	hdbc ifNotNil:[
		ODBCLibrary default sqlDisconnect: hdbc.
		ODBCLibrary default sqlFreeConnect: hdbc.
		hdbc := nil].
	hEnv ifNotNil:[
		ODBCLibrary default sqlFreeEnv: hEnv.
		hEnv := nil].
	self unregisterForFinalization.

]

{ #category : #transactions }
ODBCConnection >> commitTransaction [
	"commit the open transaction"
	self endTransactionCompletion:  SQLCOMMIT

]

{ #category : #connecting }
ODBCConnection >> connect [
	"Connect to the database"
	self registerForFinalization.
	hEnv := self sqlAllocEnv.
	false ifTrue: 
		[ self 
			sqlSetEnvAttr: 200
			value: 2	"SQL_ATTR_ODBC_VERSION" ].
	hdbc := self sqlAllocConnect: hEnv.
	(dsn asLowercase includesSubstring: 'driver={') 
		ifTrue: 
			[ self  
				sqlDriverConnect: self driverString
				completion: 0	"SQL_DRIVER_NO_PROMPT" ]
		ifFalse: 
			[ self 
				sqlConnect: dsn
				user: user
				password: password ].
	version := self sqlGetInfoString: 77.	"SQL_DRIVER_ODBC_VER"
	Transcript
		cr;
		show: 'ODBC Version: ' , version.
	self checkFeatures.
	connected := true
]

{ #category : #connecting }
ODBCConnection >> driverString [
	"Answers the driver string for a dsn-less connection"
	^String streamContents:[:s |
		s nextPutAll: dsn; nextPutAll: ';UID='; nextPutAll: user; nextPutAll: ';PWD='; nextPutAll: password
	].
]

{ #category : #accessing }
ODBCConnection >> dsn: dsnString [ 
	"change the receiver's dsn"
	self checkNotConnected.
	dsn := dsnString
]

{ #category : #transactions }
ODBCConnection >> endTransactionCompletion: anInteger [ 
	"private - close the transaction with completion ROOLBACK o COMMIT"
	self checkConnected.
	openTransaction
		ifFalse: [^ self error: 'not opened transaction!'].
	self
		checkSQLReturn: (ODBCLibrary default
				sqlEndTran: SQLHANDLEDBC
				handle: hdbc
				completionType: anInteger).
openTransaction := false.
]

{ #category : #transactions }
ODBCConnection >> ensureAutoCommitOff [
	"ensure auto commit false"
	self autoCommit
		ifTrue: [self autoCommit: false]
]

{ #category : #statements }
ODBCConnection >> execute: queryString [
	"Execute the given query without any arguments"
	^self execute: queryString args: #()
]

{ #category : #statements }
ODBCConnection >> execute: queryString args: args [
	"Execute the given query with the provided arguments"
	| stmt result |
	stmt := ODBCStatement connection: self query: queryString.
	result := stmt execute: args.
	^result
]

{ #category : #'private - finalization' }
ODBCConnection >> finalize [
	self closeNotFail
]

{ #category : #'private - errors' }
ODBCConnection >> getErrorSQLReturn: sqlReturn environment: anEnvironmentHandle connection: aConnectionHandle statement: aStatementHandle [ 
	"private - check the sqlReturn and generates an exception if corresponds"
	| stateString nativeError messateTextString textLenght envHandle conHandle staHandle details exception |
	envHandle := anEnvironmentHandle
				ifNil: [SQLHENV new].
	conHandle := aConnectionHandle
				ifNil: [SQLHDBC new].
	staHandle := aStatementHandle
				ifNil: [SQLHSTMT new].
	details := OrderedCollection new.
	""
	[stateString := String new: 6.
	nativeError := SQLInteger new.
	messateTextString := String new: BUFFERSIZE.
	textLenght := SQLSmallInteger new.
""
	(ODBCLibrary default
		sqlErrorEnvironment: envHandle
		connection: conHandle
		statement: staHandle
		state: stateString
		nativeError: nativeError
		messateText: messateTextString
		bufferLength: BUFFERSIZE
		textLength: textLenght)
		== SQLSUCCESS]
		whileTrue: [""
			details
				add: (ODBCErrorDetail
						state: stateString
						message: (messateTextString first: textLenght value)
						nativeError: nativeError value)].
	""
	exception := (sqlReturn == SQLSUCCESSWITHINFO
				ifTrue: [ODBCWarning]
				ifFalse: [ODBCError])
				details: details.
	self log: exception.
	exception signal
]

{ #category : #private }
ODBCConnection >> handle [
	"private - answer the receiver's handle"
	^ hdbc
]

{ #category : #initialization }
ODBCConnection >> initialize [
	"initialize the receiver"
	connected := false.
	dsn := ''.
	user := ''.
	password := ''.
	statements := WeakSet new.
	openTransaction := false.
	asyncStatements := false.
]

{ #category : #initialization }
ODBCConnection >> initializeDsn: dsnString user: userString password: passwordString [ 
	"initialize the receiver"
	dsn := dsnString.
	user := userString.
	password := passwordString
]

{ #category : #query }
ODBCConnection >> isConnected [
	"answer if the receiver is connected"
	^ connected
]

{ #category : #private }
ODBCConnection >> log: anObject [ 
	"private - log a message"
	self class log: anObject
]

{ #category : #statements }
ODBCConnection >> newPreparedStatement [
	"Answer a new prepared statement without any associated query"
	^ODBCPreparedStatement connection: self query: nil.
]

{ #category : #connecting }
ODBCConnection >> open [
	"open the connection"
	self isConnected ifTrue: [
		self log: 'connected!'.
		^ self].
	self connect.
]

{ #category : #accessing }
ODBCConnection >> password: passwordString [ 
	"change the receiver's password"
	self checkNotConnected.
	password := passwordString
]

{ #category : #statements }
ODBCConnection >> prepare: aString [ 
	"creates a new prepared statement for queryString"
	self checkConnected.
	^ ODBCPreparedStatement connection: self query: aString
]

{ #category : #printing }
ODBCConnection >> printOn: aStream [ 
	super printOn: aStream.
	aStream nextPutAll: ', dsn:';
		 nextPutAll: dsn asString;
		 nextPutAll: ', user:';
		 nextPutAll: user asString;
		 nextPutAll: ', password:';
		 nextPutAll: password asString.
	aStream
		nextPutAll: (self isConnected
				ifTrue: [' (connected)']
				ifFalse: [' (not connected)']).
	aStream
		nextPutAll: (openTransaction
				ifTrue: [' (not open transaction)']
				ifFalse: [' (open transaction)']).
	 
]

{ #category : #statements }
ODBCConnection >> query: aString [ 
	"creates a new statement for queryString"
	self checkConnected.
	^ ODBCStatement connection: self query: aString
]

{ #category : #'private - finalization' }
ODBCConnection >> registerForFinalization [
	"private - register the receiver to the class side registry for finalization  
	notification"
	self class register: self
]

{ #category : #statements }
ODBCConnection >> resultSetFor: aString [ 
	| secondTry |
	secondTry := false.
	^ [ (self query: aString) execute ] 
		on: ODBCError
		do: 
			[ :err | 
			"try to connect to server one time in case connection was broken"
			secondTry = true ifTrue: 
				[ err signal.
				^ nil ].
			self startUp.
			secondTry := true.
			err retry ]
]

{ #category : #transactions }
ODBCConnection >> rollbackTransaction [
	"rollback the open transaction"
	self endTransactionCompletion: SQLROLLBACK
]

{ #category : #statements }
ODBCConnection >> run: aString [ 
	^ (self resultSetFor: aString) asTable
]

{ #category : #snapshots }
ODBCConnection >> shutDown [
	self isConnected
		ifTrue: [self closeNotFail]
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlAllocConnect: envHandle [
	| h |
	h := SQLHDBC new.
	self checkSQLReturn: (ODBCLibrary default 
		sqlAllocConnectEnvironment: hEnv connection: h
	).
	^h

]

{ #category : #'sql helpers' }
ODBCConnection >> sqlAllocEnv [
	| h |
	h := SQLHENV new.
	self checkSQLReturn: (ODBCLibrary default sqlAllocEnv: h).
	^h
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlConnect: dsnString user: userString password: passString [
	self checkSQLReturn: (ODBCLibrary default
				sqlConnect: hdbc
				dsn: dsnString
				dsnLength: dsnString size
				user: userString
				userLength: userString size
				authentication: passString
				authenticationLength: passString size).

]

{ #category : #'sql helpers' }
ODBCConnection >> sqlDisconnect: h [
	self checkSQLReturn: (ODBCLibrary default sqlDisconnect: h).
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlDriverConnect: connString completion: flags [
	| outString outStringSizePtr |
	outString := String new: 1024 withAll: $ .
	outStringSizePtr := SQLSmallInteger new.	
	self checkSQLReturn: (ODBCLibrary default 
		sqlDriverConnect: hdbc with: nil with: connString with: connString size with: outString with: outString size with: outStringSizePtr with: flags
	).
	^outString copyFrom: 1 to: outStringSizePtr value
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlFreeConnect: h [
	self checkSQLReturn: (ODBCLibrary default sqlFreeConnect: h).

]

{ #category : #'sql helpers' }
ODBCConnection >> sqlFreeEnv: h [
	self checkSQLReturn: (ODBCLibrary default sqlFreeEnv: h).

]

{ #category : #'sql helpers' }
ODBCConnection >> sqlGetConnectAttr: key [ 
	"answer an long attribute of the receiver"
	| buffer |
	self checkConnected.
	buffer := SQLInteger new.
	self checkSQLReturn: (ODBCLibrary default
		sqlGetConnectAttr: hdbc attribute: key value: buffer getHandle 
			length: SQLUINTEGER valueLength: nil).
	^ buffer value
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlGetInfoString: infoType [
	| buffer length |
	buffer := String new: 255.
	length := SQLSmallInteger new.
	self checkSQLReturn: (ODBCLibrary default 
		sqlGetInfo: hdbc with: infoType with: buffer with: buffer size with: length
	).
	^buffer copyFrom: 1 to: 1 + length value
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlSetConnectAttr: key value: value [ 
	"change a long attribute of the receiver"
	self checkConnected.
	self checkSQLReturn: (ODBCLibrary default
		sqlSetConnectAttr: hdbc attribute: key value: value length: SQLUINTEGER
	)
]

{ #category : #'sql helpers' }
ODBCConnection >> sqlSetEnvAttr: attr value: value [
	self checkSQLReturn: (ODBCLibrary default 
		sqlSetEnvAttr: hEnv attr: attr value: value length: 0
	)
]

{ #category : #snapshots }
ODBCConnection >> startUp [
	self isConnected
		ifTrue: [self connect]
]

{ #category : #transactions }
ODBCConnection >> transactionDuring: aBlock [ 
	"evaluate aBlock in a transaction  
	 
	if the block finish commit the transaction,  
	if the block fails rollback the transaction"
	| lastError |
	self beginTransaction.
	lastError := nil.
	[aBlock value]
		on: Error
		do: [:error | lastError := error].
	""
	lastError isNil
		ifTrue: [self commitTransaction]
		ifFalse: [""
			self rollbackTransaction.
			lastError signal]
]

{ #category : #'private - finalization' }
ODBCConnection >> unregisterForFinalization [
	"private - unregister the receiver to the class side registry for 
	finalization notification"
	self class unregister: self
]

{ #category : #accessing }
ODBCConnection >> user: userString [ 
	"change the receiver's user"
	self checkNotConnected.
	user := userString
]
