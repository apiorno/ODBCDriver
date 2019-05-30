"
An SQL statement
"
Class {
	#name : #ODBCStatement,
	#superclass : #Object,
	#instVars : [
		'connection',
		'handle',
		'query',
		'resultSets',
		'argBuffers'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC-Model-Core'
}

{ #category : #'instance creation' }
ODBCStatement class >> connection: aConnection query: aString [ 
	^ self new initializeConnection: aConnection query: aString 
]

{ #category : #private }
ODBCStatement >> addResulSet: aResulSet [ 
	"private - add aResultSet to the resultSets collection"
	^ resultSets add: aResulSet
]

{ #category : #executing }
ODBCStatement >> bind: arguments [
	"Bind the statement with the given args."
	| arg buf |
	argBuffers ifNil:[argBuffers := Array new: arguments size].
	1 to: arguments size do:[:i|
		arg := arguments at: i.
		buf := argBuffers at: i.
		(self fillArg: buf with: arg) ifFalse:[
			buf ifNotNil:[buf data free].
			buf := self bindArg: arg.
			argBuffers at: i put: buf.
			self sqlBindParam: i argType: buf cType sqlType: buf sqlType 
				columnSize: buf colWidth digits: buf digits 
				value: buf data length: buf size.
		].
	].

]

{ #category : #executing }
ODBCStatement >> bindArg: arg [
	"Bind the argument at the given position"
	| buf sz |
	"String arguments"
	arg isString ifTrue:[
		sz := arg size.
		buf := ExternalAddress allocate: sz.
		1 to: sz do:[:b| buf unsignedByteAt: b put: (arg byteAt: b)].
		^(ODBCBoundParameter new)
			handle: buf; cType: SQLCCHAR; sqlType: SQLVARCHAR; 
			colWidth: sz; size: sz].
	"Integer arguments"
	arg isInteger ifTrue:[
		sz := arg digitLength.
		sz <= 4 ifTrue:[
			buf := ExternalAddress allocate: 4.
			buf signedLongAt: 1 put: arg.
			^(ODBCBoundParameter new)
				handle: buf; cType: SQLCINTEGER; sqlType: SQLINTEGER; 
				colWidth: 0; size: 4].
		^self error: 'Integer out of range'].
	"Float arguments"
	arg isFloat ifTrue:[
		buf := ExternalAddress allocate: 8.
		buf doubleAt: 1 put: arg.
		^(ODBCBoundParameter new)
			handle: buf; cType: SQLCDOUBLE; sqlType: SQLDOUBLE; 
			colWidth: 0; size: 8].
	"Time arguments"
	(arg isMemberOf: Time) ifTrue:[
		buf := SQLTime externalNew.
		buf hour: arg hour.
		buf minute: arg minute.
		buf second: arg second.
		^(ODBCBoundParameter new)
			handle: buf getHandle; cType: SQLCTIME; sqlType: SQLTIME;
			colWidth: 8; size: buf byteSize].
	"Date arguments"
	(arg isMemberOf: Date) ifTrue:[
		buf := SQLDate externalNew.
		buf year: arg year.
		buf month: arg monthIndex.
		buf day: arg dayOfMonth.
		^(ODBCBoundParameter new)
			handle: buf getHandle; cType: SQLCDATE; sqlType: SQLDATE; 
			colWidth: 10; size: buf byteSize].
	"DateAndTime"
	(arg isKindOf: DateAndTime) ifTrue:[
		buf := SQLTimestamp externalNew.
		buf year: arg year.
		buf month: arg month.
		buf day: arg dayOfMonth.
		buf hour: arg hour.
		buf minute: arg minute.
		buf second: arg second.
		^(ODBCBoundParameter new)
			handle: buf getHandle; cType: SQLCTIMESTAMP; sqlType: SQLTIMESTAMP; 
			colWidth: 19; size: buf byteSize].

	^self error: 'Cannot bind argument'
]

{ #category : #private }
ODBCStatement >> checkConnected [
	"private - check if the recevier is connected"
	self isConnected
		ifFalse: [^ self error: 'unconnected!']
]

{ #category : #connecting }
ODBCStatement >> close [
	"close the receiver and all the childrents"
	self freeArgBuffers.
	resultSets do: [:each | each close].
	self unregisterForFinalization
]

{ #category : #connecting }
ODBCStatement >> closeNotFail [
	"close the receiver without signaling errors"
	self freeArgBuffers.
	resultSets do: [:each | each closeNotFail].
	self unregisterForFinalization
]

{ #category : #executing }
ODBCStatement >> execute [
	"Execute the query and answer the result"
	^self execute: #()
]

{ #category : #executing }
ODBCStatement >> execute: args [
	"Execute the query with the given arguments and answer the result"
	self checkConnected.
	self bind: args.
	self sqlExecDirect: query.
	^ODBCResultSet connection: connection statement: self
]

{ #category : #executing }
ODBCStatement >> fillArg: buf with: arg [
	"Fill a bound parameter with a new value. Answer true if successful, false otherwise"
	| argHandle |
	buf ifNil:[^false].
	argHandle := buf handle.
	argHandle isNull ifTrue:[^false].
	buf sqlType caseOf: {
		[SQLVARCHAR] -> [
			arg isString ifFalse:[^false].
			arg size > buf size ifTrue:[^false].
			1 to: arg size do:[:b| argHandle unsignedByteAt: b put: (arg byteAt: b)].
			^true
		].
		[SQLINTEGER] -> [
			arg isInteger ifFalse:[^false].
			arg digitLength > 4 ifTrue:[^false].
			argHandle signedLongAt: 1 put: arg.
			^true
		].
		[SQLDOUBLE] -> [
			arg isFloat ifFalse:[^false].
			argHandle doubleAt: 1 put: arg.
		].
		[SQLTIME] -> [
			(arg isMemberOf: Time) ifFalse:[^false].
			(SQLTime fromHandle: argHandle)
				hour: arg hour;
				minute: arg minute;
				second: arg second.
			^true
		].
		[SQLDATE] -> [
			(arg isMemberOf: Date) ifFalse:[^false].
			(SQLDate fromHandle: argHandle)
				year: arg year;
				month: arg monthIndex;
				day: arg dayOfMonth.
			^true
		].
		[SQLTIMESTAMP] -> [
			(arg isKindOf: DateAndTime) ifFalse:[^false].
			(SQLTimestamp fromHandle: argHandle)
				year: arg year;
				month: arg month;
				day: arg dayOfMonth;
				hour: arg hour;
				minute: arg minute;
				second: arg second.
			^true
		].
	} otherwise:[^false].

]

{ #category : #'private - finalization' }
ODBCStatement >> finalize [
	self closeNotFail
]

{ #category : #private }
ODBCStatement >> freeArgBuffers [
	"Free the allocate buffers"
	argBuffers ifNil:[^self].
	argBuffers do:[:each| each ifNotNil:[each data free]].
	argBuffers := nil.
]

{ #category : #executing }
ODBCStatement >> getTypeInfo [
	^self getTypeInfo: 0 "SQL_ALL_TYPES"
]

{ #category : #executing }
ODBCStatement >> getTypeInfo: dataType [
	self sqlGetTypeInfo: dataType.
	^ODBCResultSet connection: connection statement: self
]

{ #category : #accessing }
ODBCStatement >> handle [
	"answer the receiver's handle"
	^ handle
]

{ #category : #initialization }
ODBCStatement >> initializeConnection: aConnection query: aString [ 
	"initialize the receiver"
	resultSets := WeakSet new.
	query := aString.
	connection := aConnection.
	handle := self sqlAllocStmt.
	connection addStatement: self.
	connection asyncStatements ifTrue:[
		self sqlSetStmtAttr: 4 "SQL_ATTR_ASYNC_ENABLE"  
				value: 1 "SQL_ASYNC_ENABLE_ON" 
				length: 0 "ignored".
	].

]

{ #category : #query }
ODBCStatement >> isConnected [
	"answer if the receiver is connected"
	^ connection isConnected
]

{ #category : #printing }
ODBCStatement >> printOn: aStream [ 
	super printOn: aStream.
	aStream nextPutAll: ' ''';
		 nextPutAll: query asString;
		 nextPutAll: ''''.
	aStream
		nextPutAll: (self isConnected
				ifTrue: [' (connected)']
				ifFalse: [' (not connected)'])
]

{ #category : #accessing }
ODBCStatement >> query [
	"answer the receiver's query"
	^ query
]

{ #category : #accessing }
ODBCStatement >> query: queryString [
	query := queryString
]

{ #category : #'private - finalization' }
ODBCStatement >> registerForFinalization [
	"private - register the receiver to the class side registry for finalization  
	notification"
	connection class register: self
]

{ #category : #'sql helpers' }
ODBCStatement >> sqlAllocStmt [
	| h |
	h := SQLHSTMT new.
	connection checkSQLReturn: (ODBCLibrary default 
			sqlAllocStmtConnection: connection handle 
			statement: h) 
		statement: h.
	^h
]

{ #category : #'sql helpers' }
ODBCStatement >> sqlBindParam: index argType: argType sqlType: sqlType columnSize: colSize digits: digits value: value length: length [
	| sqlLength |
	sqlLength := SQLInteger new.
	sqlLength value: length.
	connection checkSQLReturn: (ODBCLibrary default 
		sqlBindParam: handle at: index 
			appType: argType sqlType: sqlType value columSize: colSize
			digits: digits value: value length: sqlLength
	) statement: handle.

]

{ #category : #'sql helpers' }
ODBCStatement >> sqlDescribeParam: index [
	"Describe the given parameter."
	| dataType paramSize digits nullable |
	dataType := SQLSmallInteger new.
	paramSize := SQLInteger new.
	digits := SQLSmallInteger new.
	nullable := SQLSmallInteger new.
	connection checkSQLReturn: (ODBCLibrary default 
		sqlDescribeParam: handle at: index 
			dataType: dataType paramSize: paramSize digits: digits nullable: nullable
	) statement: handle.
	^(ODBCParamDescription new)
		dataType: dataType value;
		paramSize: paramSize value;
		digits: digits value;
		nullable: nullable value

]

{ #category : #'sql helpers' }
ODBCStatement >> sqlExecDirect: queryString [
	connection checkSQLReturn: (ODBCLibrary default 
		sqlExecDirect: handle statement: queryString length: queryString size
	) statement: handle.

]

{ #category : #'sql helpers' }
ODBCStatement >> sqlExecute [
	connection
		checkSQLReturn: (ODBCLibrary default sqlExecute: handle)
		statement: handle.
]

{ #category : #'sql helpers' }
ODBCStatement >> sqlGetTypeInfo: dataType [
	connection checkSQLReturn: (ODBCLibrary default 
		sqlGetTypeInfo: handle with: dataType
	) statement: handle
]

{ #category : #'sql helpers' }
ODBCStatement >> sqlNumParams [
	"Answers the number of parameters in the statement"
	| count |
	count := SQLSmallInteger new.
	connection checkSQLReturn: (ODBCLibrary default 
		sqlNumParams: handle into: count
	) statement: handle.
	^count value

]

{ #category : #'sql helpers' }
ODBCStatement >> sqlPrepare: queryString [
	connection checkSQLReturn: (ODBCLibrary default 
		sqlPrepare: handle statement: queryString length: queryString size
	) statement: handle.

]

{ #category : #'sql helpers' }
ODBCStatement >> sqlSetStmtAttr: attr value: value length: length [
	connection checkSQLReturn: (ODBCLibrary default 
			sqlSetStmtAttr: handle name: attr value: value length: length
	) statement: handle.

]

{ #category : #'private - finalization' }
ODBCStatement >> unregisterForFinalization [
	"private - unregister the receiver to the class side registry for  
	finalization notification"
	connection class unregister: self
]
