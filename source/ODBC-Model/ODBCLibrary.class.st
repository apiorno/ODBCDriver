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
	^ default ifNil:[default := self uniqueInstance ]
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
	
	"#define SQL_HANDLE_ENV              1
 #define SQL_HANDLE_DBC              2
 #define SQL_HANDLE_STMT             3
 #define SQL_HANDLE_DESC 				4
 #define SQL_NULL_HANDLE  				0"

	"self
		ffiCall: #(short SQLAllocHandle #(2 , SQLHENV environmentHandle , SQLHDBC connectionHandle))"

	self ffiCall: #(short SQLAllocConnect (SQLHENV environmentHandle , SQLHDBC connectionHandle))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlAllocEnv: environmentHandle [
	"SQLRETURN SQLAllocEnv(SQLHENV *EnvironmentHandle);"

"#define SQL_HANDLE_ENV              1
 #define SQL_HANDLE_DBC              2
 #define SQL_HANDLE_STMT             3
 #define SQL_HANDLE_DESC 				4
 #define SQL_NULL_HANDLE  				0"

	"self
		ffiCall: #(short SQLAllocHandle #(1 , 0 , SQLHENV environmentHandle))"
	self ffiCall: #(short SQLAllocEnv (SQLHENV environmentHandle))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlAllocHandleType: aHandleType inputHandle: anInputHandle outputHandle: anOutputHandle [
	"SQLRETURN SQLAllocHandle(  
      SQLSMALLINT   HandleType,  
      SQLHANDLE     InputHandle,  
      SQLHANDLE *   OutputHandlePtr); "

	self ffiCall: #(short SQLAllocHandle (SQLSmallInteger aHandleType, SQLHANDLE anInputHandle, SQLHANDLE *anOutputHandle ))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlAllocStmtConnection: environmentHandle statement: statementHandle [ 
	"SQLRETURN
	SQLAllocStmt(
	SQLHDBC ConnectionHandle,
	SQLHSTMT *StatementHandle); "

	self ffiCall: #(short SQLAllocStmt (SQLHDBC environmentHandle , SQLHSTMT *statementHandle))
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

	self ffiCall: #(short SQLBindCol (SQLHSTMT statementHandle, ushort columnNumber, short targetType, void* targetValue, long bufferLength, SQLInteger* strLenght))
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

	self ffiCall: #(short SQLBindParam (SQLHSTMT statementHandle, ushort paramIdx, short dtype, short ptype, ulong sz, short digits, void* vptr, SQLInteger *lenPtr))
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

	self ffiCall: #(short SQLBindParam (SQLHSTMT statementHandle, ushort paramIdx, short ioType, short dtype, short ptype, ulong sz, short digits, void* vptr,  long bfsz, SQLInteger *lenPtr))
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

	self ffiCall: #(short SQLConnect (SQLHDBC connectionHandle, char *dsnString, short dsnLengthInteger, char *userString, short userLengthInteger, char *authenticationString, short authenticationLengthInteger))
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

	self ffiCall: #(short SQLDescribeCol (SQLHSTMT statementHandle, ushort columnCount, char *columnName, short bufferLength, SQLSmallInteger *nameLength, SQLSmallInteger *dataType, SQLUInteger *columnSize, SQLSmallInteger *decimalDigits, SQLSmallInteger *nullable))
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

	self ffiCall: #(short SQLDescribeParam (SQLHSTMT statementHandle, ushort paramIdx, SQLSmallInteger *typePtr, SQLInteger *lengthPtr SQLSmallInteger *scalePtr SQLSmallInteger *nullable))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlDisconnect: connectionHandle [ 
	"SQLRETURN SQLDisconnect(SQLHDBC ConnectionHandle);"

	self ffiCall: #(short 'SQLDisconnect' (SQLHDBC connectionHandle))
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

	self ffiCall: #(short SQLDriverConnect (SQLHDBC connectionHandle, Win32Handle hWnd, char *inConnStr, short inStrLength, char *outStrLength, short outStrLength, SQLSmallInteger *outSizePtr, ulong flags))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlEndTran: type handle: aHandle completionType: completionType [
	"SQLRETURN
	SQLEndTran(
	SQLSMALLINT HandleType,
	SQLHANDLE Handle,
     SQLSMALLINT CompletionType);"

	self ffiCall: #(short SQLEndTran (short type, SQLHDBC aHandle, short completionType))
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

	self ffiCall: #(short SQLError (SQLHENV environmentHandle, SQLHDBC connectionHandle, SQLHSTMT statementHandle,void* stateString, SQLInteger nativeError, void* messateTextString, short bufferLengthInteger, SQLSmallInteger textLenghtInteger))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlExecDirect: statementHandle statement: statementString length: statementLength [ 
	"SQLRETURN
	SQLExecDirect(
	SQLHSTMT StatementHandle,
 	SQLCHAR *StatementText,
	SQLINTEGER TextLength);"

	self ffiCall: #(short SQLExecDirect (SQLHSTMT statementHandle, char *statementString, long statementLength))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlExecute: hstmt [
	"SQLRETURN SQL_API SQLExecute(
		SQLHSTMT		hstmt);"

	self ffiCall: #(short SQLExecute (SQLHSTMT hstmt))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlFetch: statementHandle [ 
	"SQLRETURN SQLFetch(SQLHSTMT StatementHandle);"

	self ffiCall: #(short SQLFetch (SQLHSTMT statementHandle))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlFreeConnect: connectionHandle [ 
	"SQLRETURN SQLFreeConnect(SQLHDBC ConnectionHandle);"

	self ffiCall: #(short SQLFreeConnect (SQLHDBC connectionHandle))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlFreeEnv: environmentHandle [ 
	"SQLRETURN SQLFreeEnv(SQLHENV EnvironmentHandle);"

	self ffiCall: #(short SQLFreeEnv (SQLHENV environmentHandle))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlFreeStmt: statementHandle option: optionInteger [ 
	"SQLRETURN
	SQLFreeStmt(
	SQLHSTMT StatementHandle,
	SQLUSMALLINT Option); "

	self ffiCall: #(short SQLFreeStmt (SQLHSTMT statementHandle, ushort optionInteger))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlGetConnectAttr: connectionHandle attribute: attribute value: value length: length valueLength: valueLength [
	"SQLRETURN SQLGetConnectAttr(
     SQLHDBC     ConnectionHandle,
     SQLINTEGER     Attribute,
     SQLPOINTER     ValuePtr,
     SQLINTEGER     BufferLength,
     SQLINTEGER *     StringLengthPtr);"

	self ffiCall: #(short SQLGetConnectAttr (SQLHDBC connectionHandle, long attribute, void* value, long length, SQLInteger *valueLength))
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

	self ffiCall: #(short SQLGetData (SQLHSTMT statementHandle, ulong columnNumber, short targetType, void* targetValue, long bufferLength, SQLInteger *strLenght))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlGetInfo: hdbc with: infoType with: resultPtr with: size with: resultLenPtr [
	"SQLRETURN SQLGetInfo(
		SQLHDBC     ConnectionHandle,
		SQLUSMALLINT     InfoType,
		SQLPOINTER     InfoValuePtr,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *     StringLengthPtr);"

	self ffiCall: #(short SQLGetInfo (SQLHDBC hdbc, ushort infoType, void* resultPtr, short size, SQLSmallInteger *resultLenPtr))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlGetTypeInfo: hstmt with: dataType [
	"SQLRETURN SQLGetTypeInfo(
		SQLHSTMT     StatementHandle,
		SQLSMALLINT     DataType);"

	self ffiCall: #(short SQLGetTypeInfo (SQLHSTMT hstmt, ushort dataType))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlNumParams: statementHandle into: shortArray [
	"SQLRETURN
	SQLNumParams(
	SQLHSTMT StatementHandle,
 	SQLSMALLINT *pcpar);"

	self ffiCall: #(short SQLNumParams (SQLHSTMT statementHandle, SQLSmallInteger *shortArray))
]

{ #category : #'primitives - resultset' }
ODBCLibrary >> sqlNumResultCols: statementHandle columnCount: columnCount [ 
	"SQLRETURN
	SQLNumResultCols(
	SQLHSTMT StatementHandle,
	SQLSMALLINT *ColumnCount); "

	self ffiCall: #(short SQLNumResultCols (SQLHSTMT statementHandle, SQLSmallInteger *columnCount))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlPrepare: statementHandle statement: statementString length: statementLength [ 
	"SQLRETURN
	SQLPrepare(
	SQLHSTMT StatementHandle,
 	SQLCHAR *StatementText,
	SQLINTEGER TextLength);"

	self ffiCall: #(short SQLPrepare (SQLHSTMT statementHandle, char *statementString, long  statementLength))
]

{ #category : #'primitives - resultset' }
ODBCLibrary >> sqlRowCount: statementHandle rowCount: rowCount [ 
	"SQLRETURN
	SQLRowCount(
	SQLHSTMT StatementHandle,
	SQLSMALLINT *RowCount); "

	self ffiCall: #(short SQLRowCount (SQLHSTMT statementHandle, SQLSmallInteger *rowCount))
]

{ #category : #'primitives - connections' }
ODBCLibrary >> sqlSetConnectAttr: connectionHandle attribute: attribute value: value length: length [ 
	"SQLRETURN SQLSetConnectAttr(  
	SQLHDBC ConnectionHandle,  
	SQLINTEGER Attribute,  
	SQLPOINTER ValuePtr,  
	SQLINTEGER StringLength);"

	self ffiCall: #(short SQLSetConnectAttr (SQLHDBC connectionHandle, long attribute, long value, long length))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlSetEnvAttr: hEnv attr: attr value: value length: length [ 
	"SQLRETURN SQLSetEnvAttr(
		SQLHENV     EnvironmentHandle,
		SQLINTEGER     Attribute,
		SQLPOINTER     ValuePtr,
		SQLINTEGER     StringLength);"

	self ffiCall: #(short SQLSetEnvAttr (SQLHENV hEnv, long attr, long value, long length))
]

{ #category : #'primitives - environments' }
ODBCLibrary >> sqlSetEnvAttrPtr: hEnv attr: attr value: value length: length [ 
	"SQLRETURN SQLSetEnvAttr(
		SQLHENV     EnvironmentHandle,
		SQLINTEGER     Attribute,
		SQLPOINTER     ValuePtr,
		SQLINTEGER     StringLength);"

	self ffiCall: #(short SQLSetEnvAttr (SQLHENV hEnv, long attr, void* value, long length))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlSetStmtAttr: statementHandle name: attr value: value length: length [
	"NOTE: Use sqlSetStmtAttrPtr: if you need to pass a pointer for the value."
	"SQLRETURN  SQL_API SQLSetStmtAttr(
		SQLHSTMT StatementHandle,
		SQLINTEGER Attribute, 
		SQLPOINTER Value,
		SQLINTEGER StringLength);"

	self ffiCall: #(short SQLSetStmtAttr (SQLHSTMT statementHandle, long attr, ulong value, long length))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlSetStmtAttrPtr: statementHandle name: attr value: value length: length [
	"SQLRETURN  SQL_API SQLSetStmtAttr(
		SQLHSTMT StatementHandle,
		SQLINTEGER Attribute, 
		SQLPOINTER Value,
		SQLINTEGER StringLength);"

	self ffiCall: #(short SQLSetStmtAttr (SQLHSTMT statementHandle, long attr, void* value, long length))
]

{ #category : #'primitives - statements' }
ODBCLibrary >> sqlSetStmtOption: statementHandle name: attr value: value [
	"SQLRETURN  SQL_API SQLSetStmtOption(
		SQLHSTMT StatementHandle,
		SQLUSMALLINT Option, 
		SQLROWCOUNT Value);"

	self ffiCall: #(short SQLSetStmtOption (SQLHSTMT statementHandle, ushort attr, ulong value))
]

{ #category : #'as yet unclassified' }
ODBCLibrary >> unixModuleName [

	^ 'libodbc.so'
]

{ #category : #'as yet unclassified' }
ODBCLibrary >> win32ModuleName [

	^ 'odbc32'
]
