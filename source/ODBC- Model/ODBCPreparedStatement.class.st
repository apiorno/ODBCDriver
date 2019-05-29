"
A prepared statement for higher efficiency
"
Class {
	#name : #ODBCPreparedStatement,
	#superclass : #ODBCStatement,
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC- Model-Core'
}

{ #category : #executing }
ODBCPreparedStatement >> execute: args [
	"Execute the query with the given arguments and answer the result"
	self checkConnected.
	self bind: args.
	self sqlExecute.
	^ODBCResultSet connection: connection statement: self
]

{ #category : #initialization }
ODBCPreparedStatement >> initializeConnection: aConnection query: aString [ 
	super initializeConnection: aConnection query: aString.
	self sqlPrepare: query.
]
