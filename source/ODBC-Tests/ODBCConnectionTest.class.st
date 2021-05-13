Class {
	#name : #ODBCConnectionTest,
	#superclass : #TestCase,
	#category : #'ODBC-Tests'
}

{ #category : #tests }
ODBCConnectionTest >> testConnection [
	| conn stmt |
	conn := ODBCConnection dsn: 'someDsn' user: 'someUser'  password: 'somePassword'.
	self assert: conn isConnected equals: true.
	stmt := ODBCStatement connection: conn query: 'SELECT * FROM someTable'.
	stmt execute.
	conn close.
	self assert: conn isConnected equals: false.
]
