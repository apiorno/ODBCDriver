"
A set of results from an ODBC database query
"
Class {
	#name : #ODBCResultSet,
	#superclass : #Stream,
	#instVars : [
		'connection',
		'statement',
		'handle',
		'columns',
		'nextRow'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC- Model-Definitions'
}

{ #category : #'instance creation' }
ODBCResultSet class >> connection: aConnection statement: aStatement [ 
	^ self basicNew initializeConnection: aConnection statement: aStatement 
]

{ #category : #converting }
ODBCResultSet >> asTable [
	^ ODBCResultTable newFrom: self
]

{ #category : #testing }
ODBCResultSet >> atEnd [
	self checkConnected.
	^ nextRow isNil
]

{ #category : #private }
ODBCResultSet >> checkConnected [
	"private - check if the recevier is connected"
	self isConnected
		ifFalse: [^ self error: 'unconnected!']
]

{ #category : #connecting }
ODBCResultSet >> close [
	"close the receiver"
	self isConnected
		ifFalse: [^ self].
columns notNil ifTrue:[
	columns
		do: [:each | each free]].
	""
	"SQL:=DROP"
	connection
		checkSQLReturn: (ODBCLibrary default sqlFreeStmt: handle option: 1)
		statement: handle.
	handle := nil.
	self unregisterForFinalization
]

{ #category : #connecting }
ODBCResultSet >> closeNotFail [
	"close the receiver without signaling errors"
	self isConnected
		ifFalse: [^ self].
columns notNil ifTrue:[
	columns
		do: [:each | each free]].
	""
	"SQL:=DROP"
	ODBCLibrary default sqlFreeStmt: handle option: 1.
	handle := nil.
	self unregisterForFinalization
]

{ #category : #testing }
ODBCResultSet >> closed [
	"asnwer if the receiver is closed"
	^ self isConnected not
]

{ #category : #accessing }
ODBCResultSet >> columnNames [
	"Answer the receiver's columns names."
	
	^self columns  collect: [ :each | each name ]
]

{ #category : #accessing }
ODBCResultSet >> columns [
	"answer the receiver's columns.

	It's an array of ODBCColumns with metadata information"
	^ columns
]

{ #category : #accessing }
ODBCResultSet >> connection [
	"answer the receiver's connection"
	^ connection
]

{ #category : #accessing }
ODBCResultSet >> contents [
	^ self shouldNotImplement
]

{ #category : #private }
ODBCResultSet >> fetchNextRow [
	"private - fetch the next row"
	nextRow := self fetchRow
]

{ #category : #accessing }
ODBCResultSet >> fetchRow [
	"private - fetch the next row"
	| row ret |
	ret := ODBCLibrary default sqlFetch: handle.
	ret == SQLNODATAFOUND ifTrue: [^ nil].
	connection checkSQLReturn: ret statement: handle.
	""
	row := ODBCRow new: columns size.
	columns do: [:each | row at: each name put: each data]. 
	^ row
]

{ #category : #'private - finalization' }
ODBCResultSet >> finalize [
	self closeNotFail
]

{ #category : #accessing }
ODBCResultSet >> handle [
	^ handle
]

{ #category : #initialization }
ODBCResultSet >> initializeConnection: aConnection statement: aStatement [ 
	"initialize the receiver"
	| columnCount |
	connection := aConnection.
	statement := aStatement.
	statement addResulSet: self.
	handle := statement handle.
	self registerForFinalization.

	columnCount := SQLSmallInteger new.
	connection
		checkSQLReturn: (ODBCLibrary default sqlNumResultCols: handle columnCount: columnCount)
		statement: handle.
	columns := (1 to: columnCount value)
				collect: [:each | ODBCColumn resultSet: self number: each].
	""
	columns notEmpty
		ifTrue: [self fetchNextRow]
]

{ #category : #testing }
ODBCResultSet >> isConnected [
	"answer if the receiver is connected"
	^ handle notNil
]

{ #category : #accessing }
ODBCResultSet >> next [
	"answer the next row, nil if none"
	| result |
self checkConnected.
	result := nextRow.
	result notNil
		ifTrue: [self fetchNextRow].
	^ result
]

{ #category : #accessing }
ODBCResultSet >> nextPut: anObject [ 
	^ self shouldNotImplement
]

{ #category : #printing }
ODBCResultSet >> printContentsOn: stream [
	stream
		nextPutAll: (self isConnected
				ifTrue: [' (connected)']
				ifFalse: [' (not connected)'])
]

{ #category : #'private - finalization' }
ODBCResultSet >> registerForFinalization [
	"private - register the receiver to the class side registry for finalization  
	notification"
	connection class register: self
]

{ #category : #accessing }
ODBCResultSet >> rowCount [
	"answer the receiver's rowCount

	use with carefull, some odbc drivers answer -1
	"
	| rows |
	rows := SQLSmallInteger new.
	connection
		checkSQLReturn: (ODBCLibrary default sqlRowCount: handle rowCount: rows)
		statement: handle.
	^ rows value
]

{ #category : #'private - finalization' }
ODBCResultSet >> unregisterForFinalization [
	"private - unregister the receiver to the class side registry for  
	finalization notification"
	connection class unregister: self
]
