"
A database column
"
Class {
	#name : #ODBCColumn,
	#superclass : #Object,
	#instVars : [
		'connection',
		'resultSet',
		'resultSetHandle',
		'number',
		'name',
		'dataType',
		'cType',
		'convertSelector',
		'initializeSelector',
		'size',
		'decimals',
		'nullable',
		'buffer',
		'bufferLenght'
	],
	#classVars : [
		'DataTypes'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC- Model-Definitions'
}

{ #category : #'data types' }
ODBCColumn class >> cTypeFor: anInteger [ 
	"answer the cType for anInteger"
	DataTypes
		at: anInteger
		ifPresent: [:pair | ^ pair third].
	^ SQLCCHAR
]

{ #category : #'data types' }
ODBCColumn class >> convertBufferSelectorFor: anInteger [ 
	"answer the datatype selector for anInteger"
	DataTypes
		at: anInteger
		ifPresent: [:pair | ^ pair second].
	^ #stringData
]

{ #category : #'data types' }
ODBCColumn class >> dataTypeNameFor: anInteger [ 
	"answer the datatype name for anInteger"
	DataTypes
		at: anInteger
		ifPresent: [:pair | ^ pair first].
	^ #UNKOWN
]

{ #category : #'class initialization' }
ODBCColumn class >> initialize [
	ODBCConstants initialize. "must be initialized first"
	self initializeDataTypes
]

{ #category : #'data types' }
ODBCColumn class >> initializeBufferSelectorFor: anInteger [ 
	"answer the initializer selector for anInteger"
	DataTypes
		at: anInteger
		ifPresent: [:pair | ^ pair fourth].

	^ #initializeStringBuffer
]

{ #category : #'data types' }
ODBCColumn class >> initializeDataTypes [
	DataTypes := Dictionary new.
	DataTypes at: -11 put: {#GUID. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -10 put: {#WLongVarChar. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -9 put: {#WVarChar. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -8 put: {#WChar. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -7 put: {#Bit. #booleanData. SQLCBIT. #initializeBooleanBuffer};
		 at: -6 put: {#TinyInt. #numberData. SQLCCHAR. #initializeStringBuffer};
		 at: -5 put: {#BigInt. #numberData. SQLCCHAR. #initializeStringBuffer};
		 at: -4 put: {#LongVarBinary. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -3 put: {#VarBinary. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -2 put: {#Binary. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: -1 put: {#LongVarChar. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: 0 put: {#TypeNull. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: 1 put: {#Char. #stringData. SQLCCHAR. #initializeStringBuffer};
		 at: 2 put: {#Numeric. #numberData. SQLCCHAR. #initializeStringBuffer};
		 at: 3 put: {#Decimal. #numberData. SQLCCHAR. #initializeStringBuffer};
		 at: 4 put: {#Integer. #integerData. SQLCINTEGER. #initializeIntegerBuffer};
		 at: 5 put: {#SmallInt. #smallintegerData. SQLCSMALLINTEGER. #initializeSmallintegerBuffer};
		 at: 6 put: {#Float. #doubleData. SQLCDOUBLE. #initializeDoubleBuffer};
		 at: 7 put: {#Real. #floatData. SQLCFLOAT. #initializeFloatBuffer};
		 at: 8 put: {#Double. #doubleData. SQLCDOUBLE. #initializeDoubleBuffer};
		 at: 9 put: {#Date. #dateData. SQLCDATE. #initializeDateBuffer};
		 at: 10 put: {#Time. #timeData. SQLCTIME. #initializeTimeBuffer};
		 at: 11 put: {#Timestamp. #dateTimeData. SQLCTIMESTAMP. #initializeTimestampBuffer};
		 at: 12 put: {#VarChar. #stringData. SQLCCHAR. #initializeStringBuffer}
]

{ #category : #'instance creation' }
ODBCColumn class >> resultSet: aResultSet number: anInteger [ 
	"private - creates an instance for aResultSet"
	^ self new initializeResultSet: aResultSet number: anInteger
]

{ #category : #'private - type convertion' }
ODBCColumn >> asNumber: aString [ 
	"creates a Number from aString. Could be an Integer or a Fraction"
	| stream zero sign integerPart char fractionPart scale |
	stream := aString readStream.
	""
	zero := $0 asInteger.
	sign := (stream peekFor: $-)
				ifTrue: [-1]
				ifFalse: [1].
	""
	integerPart := 0.
	[stream atEnd
		or: [(char := stream next) == $.]]
		whileFalse: [integerPart := integerPart * 10 + (char asInteger - zero)].
	""
	fractionPart := 0.
	scale := 1.
	[stream atEnd]
		whileFalse: [""
			char := stream next.
			fractionPart := fractionPart * 10 + (char asInteger - zero).
			scale := scale * 10].
	""
	^ sign * (integerPart * scale + fractionPart / scale)
]

{ #category : #initialization }
ODBCColumn >> bindBuffer [
	"bind the column's buffer"
	| bufferSize bufferHandle |
	cType == SQLCCHAR 
		ifTrue: 
			[ ""
			bufferSize := BUFFERSIZE.
			bufferHandle := buffer ]
		ifFalse: 
			[ ""
			bufferSize := buffer class byteSize.
			bufferHandle := buffer isExternalAddress 
				ifTrue: [ buffer ]
				ifFalse: [ buffer getHandle ] ].
	connection 
		checkSQLReturn: (ODBCLibrary default 
				sqlBindCol: resultSetHandle
				columnNumber: number
				targetType: cType
				targetValue: (ExternalData 
						fromHandle: bufferHandle
						type: ExternalType void)
				bufferLength: bufferSize
				strLength: bufferLenght)
		statement: resultSetHandle
]

{ #category : #'private - type convertion' }
ODBCColumn >> booleanData [
	"answer the data for this column in the current row as a Boolean"
^ buffer value ~~ 0
]

{ #category : #data }
ODBCColumn >> data [
	"answer the data for this column in the current row"
"
	connection
		checkSQLReturn: (ODBCLibrary default
				sqlGetTimestampData: resultSetHandle
				columnNumber: number
				targetType: cType
				targetValue: buffer
				bufferLength: bufferHandle size
				strLength: bufferLenght)
		statement: resultSetHandle.
"
	^ bufferLenght value == SQLNULLDATA
		ifFalse: [self perform: convertSelector]
]

{ #category : #'private - type convertion' }
ODBCColumn >> dateData [
	"answer the data for this column in the current row as a Date"
	^ Date
		newDay: buffer day
		month: buffer month
		year: buffer year
]

{ #category : #'private - type convertion' }
ODBCColumn >> dateTimeData [
	"answer the data for this column in the current row as a Date/Time"
	^TimeStamp 
		year: buffer year
		month: buffer month
		day: buffer day
		hour: buffer hour
		minute: buffer minute
		second: buffer second

]

{ #category : #accessing }
ODBCColumn >> decimals [
	"answer the receiver's decimals"
	^ decimals
]

{ #category : #'private - type convertion' }
ODBCColumn >> doubleData [
	"answer the data for this column in the current row as an Double"
	^ buffer value
]

{ #category : #'private - type convertion' }
ODBCColumn >> floatData [
	"answer the data for this column in the current row as an Float"
	^ buffer value
]

{ #category : #initialization }
ODBCColumn >> free [
	"free the associated resources"
	bufferLenght notNil
		ifTrue: [bufferLenght free].
	buffer notNil
		ifTrue: [buffer free]
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeBooleanBuffer [
	buffer := SQLByte externalNew
]

{ #category : #initialization }
ODBCColumn >> initializeDataType: anInteger [ 
	dataType := self class dataTypeNameFor: anInteger.
	convertSelector := self class convertBufferSelectorFor: anInteger.
	initializeSelector := self class initializeBufferSelectorFor: anInteger.

	cType := self class cTypeFor: anInteger
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeDateBuffer [
	buffer := SQLDate externalNew
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeDoubleBuffer [
	buffer := SQLDouble externalNew
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeFloatBuffer [
	buffer := SQLFloat externalNew
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeIntegerBuffer [
	buffer := SQLInteger externalNew
]

{ #category : #initialization }
ODBCColumn >> initializeResultSet: aResultSet number: anInteger [ 
	"initialize the receiver"
	| columnName nameLenght columDataType columnSize decimalDigits columnNullable |
	resultSet := aResultSet.
	connection := resultSet connection.
	resultSetHandle := resultSet handle.
	number := anInteger.
	""
	columnName := String new: BUFFERSIZE.
	nameLenght := SQLSmallInteger new.
	columDataType := SQLSmallInteger new.
	columnSize := SQLUInteger new.
	decimalDigits := SQLSmallInteger new.
	columnNullable := SQLSmallInteger new.
	""
	connection
		checkSQLReturn: (ODBCLibrary default
				sqlDescribeCol: resultSetHandle
				columnNumber: number
				columnName: columnName
				bufferLength: BUFFERSIZE
				nameLength: nameLenght
				dataType: columDataType
				columnSize: columnSize
				decimalDigits: decimalDigits
				nullable: columnNullable)
		statement: resultSetHandle.
	""
	name := (columnName first: nameLenght value) asSymbol.
	size := columnSize value.
	decimals := decimalDigits value.
	nullable := columnNullable value = 1.
	""
	self initializeDataType: columDataType value.
	""
	self perform: initializeSelector.
	bufferLenght := SQLInteger externalNew.
	""
	self bindBuffer
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeSmallintegerBuffer [
	buffer := SQLShort externalNew
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeStringBuffer [
	buffer := ExternalAddress allocate: BUFFERSIZE
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeTimeBuffer [
	buffer := SQLTime externalNew
]

{ #category : #'initialization - buffer' }
ODBCColumn >> initializeTimestampBuffer [
	buffer := SQLTimestamp externalNew
]

{ #category : #'private - type convertion' }
ODBCColumn >> integerData [
	"answer the data for this column in the current row as an Integer"

	^ buffer value
]

{ #category : #accessing }
ODBCColumn >> name [
	"answer the receiver's name"
	^ name
]

{ #category : #accessing }
ODBCColumn >> nullable [
	"answer if the receiver is nullable"
	^ nullable
]

{ #category : #'private - type convertion' }
ODBCColumn >> numberData [
	"answer the data for this column in the current row as a Number"

	^ self asNumber: self stringFromBuffer
]

{ #category : #printing }
ODBCColumn >> printOn: aStream [ 
	super printOn: aStream.
	aStream nextPutAll: ' ';
		 nextPutAll: name asString;
		 nextPutAll: ' (';
		 nextPutAll: dataType asString;
		 nextPutAll: ' ';
		 nextPutAll: size asString.
	decimals isZero
		ifFalse: [""
			aStream nextPutAll: ',';
				 nextPutAll: decimals asString].

	aStream 
		 nextPutAll: (nullable ifTrue:[' nullable'] ifFalse:[' not nullable']);
		 nextPutAll: ')'
]

{ #category : #accessing }
ODBCColumn >> size [
	^ size
]

{ #category : #'private - type convertion' }
ODBCColumn >> smallintegerData [
	"answer the data for this column in the current row as an Integer"
	^ buffer value
]

{ #category : #'private - type convertion' }
ODBCColumn >> stringData [
	"answer the data for this column in the current row as a String"
	^ self stringFromBuffer 
]

{ #category : #'private - type convertion' }
ODBCColumn >> stringFromBuffer [
	"convert the buffer to a String"
	| len result |
	len := bufferLenght value min: BUFFERSIZE.
	result := String new: len.
	1 to: len do: [:index | 
		result at: index put: (buffer unsignedCharAt: index)
	].
	^ result
]

{ #category : #'private - type convertion' }
ODBCColumn >> timeData [
	"answer the data for this column in the current row as a Time"

	^ Time fromSeconds: buffer hour * 3600 + (buffer minute * 60) + buffer second
]
