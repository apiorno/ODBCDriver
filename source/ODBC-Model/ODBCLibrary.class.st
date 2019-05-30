"
The ODBC external library
"
Class {
	#name : #ODBCLibrary,
	#superclass : #FFILibrary,
	#classInstVars : [
		'default'
	],
	#category : #'ODBC-Model-Core'
}

{ #category : #'instance creation' }
ODBCLibrary class >> default [
	^ default ifNil:[default := super new]
]

{ #category : #accessing }
ODBCLibrary class >> moduleName [
	"Return the name of the module for this library"
	| osName |
	osName := Smalltalk os name.
	osName = 'Win32' ifTrue: [ ^ 'odbc32' ].
	osName = 'unix' ifTrue: [ ^ 'libodbc.so' ].
	^ self error: 'Don''t know the ODBC library name'
]

{ #category : #'instance creation' }
ODBCLibrary class >> new [
	^ self error:'use #default'
]

{ #category : #'as yet unclassified' }
ODBCLibrary >> macModuleName [

	^ 'libodbc.dylib'
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlAllocConnectEnvironment: environmentHandle connection: connectionHandle [
	"SQLRETURN
	SQLAllocConnect(
	SQLHENV EnvironmentHandle, 
	SQLHDBC *ConnectionHandle);"

	self ffiCall: #(short SQLAllocConnect (SQLHENV SQLHDBC *))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlAllocEnv: environmentHandle [
	"SQLRETURN SQLAllocEnv(SQLHENV *EnvironmentHandle);"

	self ffiCall: #(short SQLAllocEnv (SQLHENV *))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlAllocStmtConnection: environmentHandle statement: statementHandle [ 
	"SQLRETURN
	SQLAllocStmt(
	SQLHDBC ConnectionHandle,
	SQLHSTMT *StatementHandle); "

	self ffiCall: #(short SQLAllocStmt (SQLHDBC SQLHSTMT*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlBindCol: statementHandle columnNumber: columnNumber targetType: targetType targetValue: targetValue bufferLength: bufferLength strLength: strLenght [ 
	"SQLRETURN  
	SQLGetData(  
	SQLHSTMT StatementHandle,  
	SQLUSMALLINT ColumnNumber, 
	SQLSMALLINT TargetType,  
	SQLPOINTER TargetValue, 
	SQLINTEGER BufferLength,  
	SQLINTEGER *StrLen:=or:=Ind);"

	self ffiCall: #(short SQLBindCol (SQLHSTMT ushort short void* long SQLInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlBindParam: statementHandle at: paramIdx appType: dtype sqlType: ptype columSize: sz digits: digits value: vptr length: lenPtr [
	"SQLRETURN  SQL_API SQLBindParam(
		SQLHSTMT StatementHandle,
		SQLUSMALLINT ParameterNumber, 
		SQLSMALLINT ValueType,
		SQLSMALLINT ParameterType, 
		SQLULEN LengthPrecision,
		SQLSMALLINT ParameterScale, 
		SQLPOINTER ParameterValue,
		SQLLEN *StrLen_or_Ind);"

	self ffiCall: #(short SQLBindParam (SQLHSTMT ushort short short ulong short void* SQLInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlBindParameter: statementHandle at: paramIdx ioType: ioType valueType: dtype paramType: ptype columSize: sz digits: digits value: vptr bufferSize: bfsz length: lenPtr [
	"SQLRETURN SQL_API SQLBindParameter(
		SQLHSTMT		hstmt,
		SQLUSMALLINT	ipar,
		SQLSMALLINT	fParamType,
		SQLSMALLINT	fCType,
		SQLSMALLINT	fSqlType,
		SQLULEN		cbColDef,
		SQLSMALLINT	ibScale,
		SQLPOINTER	rgbValue,
		SQLLEN			cbValueMax,
		SQLLEN			*pcbValue);"

	self ffiCall: #(short SQLBindParam (SQLHSTMT ushort short short short ulong short void* long SQLInteger*))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlConnect: connectionHandle dsn: dsnString dsnLength: dsnLengthInteger user: userString userLength: userLengthInteger authentication: authenticationString authenticationLength: authenticationLengthInteger [ 
	"SQLRETURN
	SQLConnect(SQLHDBC ConnectionHandle, 
	SQLCHAR *ServerName, 
	SQLSMALLINT NameLength1, 
	SQLCHAR *UserName, 
	SQLSMALLINT NameLength2, 
	SQLCHAR *Authentication, 
	SQLSMALLINT NameLength3);"

	self ffiCall: #(short SQLConnect (SQLHDBC char* short char* short char* short))
]

{ #category : #'primitives - resultset' }
ODBCLibrary >> sqlDescribeCol: statementHandle columnNumber: columnCount columnName: columnName bufferLength: bufferLength nameLength: nameLength dataType: dataType columnSize: columnSize decimalDigits: decimalDigits nullable: nullable [ 
	"SQLRETURN
	SQLDescribeCol(
	SQLHSTMT StatementHandle, 
	SQLUSMALLINT ColumnNumber,
	SQLCHAR *ColumnName, 
	SQLSMALLINT BufferLength,
	SQLSMALLINT *NameLength, 
	SQLSMALLINT *DataType,
	SQLUINTEGER *ColumnSize, 
	SQLSMALLINT *DecimalDigits,
	SQLSMALLINT *Nullable);"

	self ffiCall: #(short SQLDescribeCol (SQLHSTMT ushort void* short SQLSmallInteger* SQLSmallInteger* SQLUInteger* SQLSmallInteger* SQLSmallInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlDescribeParam: statementHandle at: paramIdx dataType: typePtr paramSize: lengthPtr digits: scalePtr nullable: nullable [
	"SQLRETURN SQL_API SQLDescribeParam(
		SQLHSTMT		hstmt,
		SQLUSMALLINT	ipar,
		SQLSMALLINT	*pfSqlType,
		SQLULEN		*pcbParamDef,
		SQLSMALLINT	*pibScale,
		SQLSMALLINT	*pfNullable);"

	self ffiCall: #(short SQLDescribeParam (SQLHSTMT ushort SQLSmallInteger* SQLInteger* SQLSmallInteger* SQLSmallInteger*))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlDisconnect: connectionHandle [ 
	"SQLRETURN SQLDisconnect(SQLHDBC ConnectionHandle);"

	self ffiCall: #(short 'SQLDisconnect' (SQLHDBC))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlDriverConnect: connectionHandle with: hWnd with: inConnStr with: inStrLength with: outConnStr with: outStrLength with: outSizePtr with: flags [ 
	"SQLRETURN SQLDriverConnect(
		SQLHDBC     ConnectionHandle,
		SQLHWND     WindowHandle,
		SQLCHAR *     InConnectionString,
		SQLSMALLINT     StringLength1,
		SQLCHAR *     OutConnectionString,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *     StringLength2Ptr,
		SQLUSMALLINT     DriverCompletion);"

	self ffiCall: #(short SQLDriverConnect (SQLHDBC Win32Handle char* short char* short SQLSmallInteger* ulong))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlEndTran: type handle: aHandle completionType: completionType [
	"SQLRETURN
	SQLEndTran(
	SQLSMALLINT HandleType,
	SQLHANDLE Handle,
     SQLSMALLINT CompletionType);"

	self ffiCall: #(short SQLEndTran (short SQLHDBC short))
]

{ #category : #'primitives - errors' }
ODBCLibrary >> sqlErrorEnvironment: environmentHandle connection: connectionHandle statement: statementHandle state: stateString nativeError: nativeError messateText: messateTextString bufferLength: bufferLengthInteger textLength: textLenghtInteger [ 
	"SQLRETURN
	SQLError(
	SQLHENV EnvironmentHandle, 
	SQLHDBC ConnectionHandle,
	SQLHSTMT StatementHandle, 
	SQLCHAR *Sqlstate,
	SQLINTEGER *NativeError, 
	SQLCHAR *MessageText,
	SQLSMALLINT BufferLength, 
	SQLSMALLINT *TextLength);"

	self ffiCall: #(short SQLError (SQLHENV SQLHDBC SQLHSTMT void* SQLInteger* void* short SQLSmallInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlExecDirect: statementHandle statement: statementString length: statementLength [ 
	"SQLRETURN
	SQLExecDirect(
	SQLHSTMT StatementHandle,
 	SQLCHAR *StatementText,
	SQLINTEGER TextLength);"

	self ffiCall: #(short SQLExecDirect (SQLHSTMT char* long))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlExecute: hstmt [
	"SQLRETURN SQL_API SQLExecute(
		SQLHSTMT		hstmt);"

	self ffiCall: #(short SQLExecute (SQLHSTMT))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlFetch: statementHandle [ 
	"SQLRETURN SQLFetch(SQLHSTMT StatementHandle);"

	self ffiCall: #(short SQLFetch (SQLHSTMT))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlFreeConnect: connectionHandle [ 
	"SQLRETURN SQLFreeConnect(SQLHDBC ConnectionHandle);"

	self ffiCall: #(short SQLFreeConnect (SQLHDBC))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlFreeEnv: environmentHandle [ 
	"SQLRETURN SQLFreeEnv(SQLHENV EnvironmentHandle);"

	self ffiCall: #(short SQLFreeEnv (SQLHENV))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlFreeStmt: statementHandle option: optionInteger [ 
	"SQLRETURN
	SQLFreeStmt(
	SQLHSTMT StatementHandle,
	SQLUSMALLINT Option); "

	self ffiCall: #(short SQLFreeStmt (SQLHSTMT ushort))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlGetConnectAttr: connectionHandle attribute: attribute value: value length: length valueLength: valueLength [
	"SQLRETURN SQLGetConnectAttr(
     SQLHDBC     ConnectionHandle,
     SQLINTEGER     Attribute,
     SQLPOINTER     ValuePtr,
     SQLINTEGER     BufferLength,
     SQLINTEGER *     StringLengthPtr);"

	self ffiCall: #(short SQLGetConnectAttr (SQLHDBC long void* long SQLInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlGetData: statementHandle columnNumber: columnNumber targetType: targetType targetValue: targetValue bufferLength: bufferLength strLength: strLenght [ 
	"SQLRETURN 
	SQLGetData( 
	SQLHSTMT StatementHandle, 
	SQLUSMALLINT ColumnNumber,
	SQLSMALLINT TargetType, 
	SQLPOINTER TargetValue,
	SQLINTEGER BufferLength, 
	SQLINTEGER *StrLen:=or:=Ind);"

	self ffiCall: #(short SQLGetData (SQLHSTMT ulong short void* long SQLInteger*))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlGetInfo: hdbc with: infoType with: resultPtr with: size with: resultLenPtr [
	"SQLRETURN SQLGetInfo(
		SQLHDBC     ConnectionHandle,
		SQLUSMALLINT     InfoType,
		SQLPOINTER     InfoValuePtr,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *     StringLengthPtr);"

	self ffiCall: #(short SQLGetInfo (SQLHDBC ushort void* short SQLSmallInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlGetTypeInfo: hstmt with: dataType [
	"SQLRETURN SQLGetTypeInfo(
		SQLHSTMT     StatementHandle,
		SQLSMALLINT     DataType);"

	self ffiCall: #(short SQLGetTypeInfo (SQLHSTMT ushort))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlNumParams: statementHandle into: shortArray [
	"SQLRETURN
	SQLNumParams(
	SQLHSTMT StatementHandle,
 	SQLSMALLINT *pcpar);"

	self ffiCall: #(short SQLNumParams (SQLHSTMT SQLSmallInteger*))
]

{ #category : #'primitives - resultset' }
ODBCLibrary >> sqlNumResultCols: statementHandle columnCount: columnCount [ 
	"SQLRETURN
	SQLNumResultCols(
	SQLHSTMT StatementHandle,
	SQLSMALLINT *ColumnCount); "

	self ffiCall: #(short SQLNumResultCols (SQLHSTMT SQLSmallInteger*))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlPrepare: statementHandle statement: statementString length: statementLength [ 
	"SQLRETURN
	SQLPrepare(
	SQLHSTMT StatementHandle,
 	SQLCHAR *StatementText,
	SQLINTEGER TextLength);"

	self ffiCall: #(short SQLPrepare (SQLHSTMT char* long))
]

{ #category : #'primitives - resultset' }
ODBCLibrary >> sqlRowCount: statementHandle rowCount: rowCount [ 
	"SQLRETURN
	SQLRowCount(
	SQLHSTMT StatementHandle,
	SQLSMALLINT *RowCount); "

	self ffiCall: #(short SQLRowCount (SQLHSTMT SQLSmallInteger*))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlSetConnectAttr: connectionHandle attribute: attribute value: value length: length [ 
	"SQLRETURN SQLSetConnectAttr(  
	SQLHDBC ConnectionHandle,  
	SQLINTEGER Attribute,  
	SQLPOINTER ValuePtr,  
	SQLINTEGER StringLength);"

	self ffiCall: #(short SQLSetConnectAttr (SQLHDBC long long long))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlSetEnvAttr: hEnv attr: attr value: value length: length [ 
	"SQLRETURN SQLSetEnvAttr(
		SQLHENV     EnvironmentHandle,
		SQLINTEGER     Attribute,
		SQLPOINTER     ValuePtr,
		SQLINTEGER     StringLength);"

	self ffiCall: #(short SQLSetEnvAttr (SQLHENV long long long))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlSetEnvAttrPtr: hEnv attr: attr value: value length: length [ 
	"SQLRETURN SQLSetEnvAttr(
		SQLHENV     EnvironmentHandle,
		SQLINTEGER     Attribute,
		SQLPOINTER     ValuePtr,
		SQLINTEGER     StringLength);"

	self ffiCall: #(short SQLSetEnvAttr (SQLHENV long void* long))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlSetStmtAttr: statementHandle name: attr value: value length: length [
	"NOTE: Use sqlSetStmtAttrPtr: if you need to pass a pointer for the value."
	"SQLRETURN  SQL_API SQLSetStmtAttr(
		SQLHSTMT StatementHandle,
		SQLINTEGER Attribute, 
		SQLPOINTER Value,
		SQLINTEGER StringLength);"

	self ffiCall: #(short SQLSetStmtAttr (SQLHSTMT long ulong long))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlSetStmtAttrPtr: statementHandle name: attr value: value length: length [
	"SQLRETURN  SQL_API SQLSetStmtAttr(
		SQLHSTMT StatementHandle,
		SQLINTEGER Attribute, 
		SQLPOINTER Value,
		SQLINTEGER StringLength);"

	self ffiCall: #(short SQLSetStmtAttr (SQLHSTMT long void* long))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlSetStmtOption: statementHandle name: attr value: value [
	"SQLRETURN  SQL_API SQLSetStmtOption(
		SQLHSTMT StatementHandle,
		SQLUSMALLINT Option, 
		SQLROWCOUNT Value);"

	self ffiCall: #(short SQLSetStmtOption (SQLHSTMT ushort ulong))
]

{ #category : #'as yet unclassified' }
ODBCLibrary >> unixModuleName [

	^ 'libodbc.so'
]

{ #category : #'as yet unclassified' }
ODBCLibrary >> win32ModuleName [

	^ 'odbc32'
]
