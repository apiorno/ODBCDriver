"
Details about an error
"
Class {
	#name : #ODBCErrorDetail,
	#superclass : #Object,
	#instVars : [
		'state',
		'message',
		'nativeError'
	],
	#pools : [
		'ODBCConstants'
	],
	#category : #'ODBC-Model-Definitions'
}

{ #category : #'instance creation' }
ODBCErrorDetail class >> state: stateString message: messageString nativeError: nativeErrorNumber [ 
	^ self new
		initializeState: stateString
		message: messageString
		nativeError: nativeErrorNumber
]

{ #category : #initialization }
ODBCErrorDetail >> initializeState: stateString message: messageString nativeError: nativeErrorNumber [ 
	"initialize the receiver"
	state := stateString.
	message := messageString.
	nativeError := nativeErrorNumber.

]

{ #category : #printing }
ODBCErrorDetail >> printOn: aStream [ 
	aStream nextPutAll: '[State:';
		 nextPutAll: state asString;
		 nextPutAll: '] [NativeError:';
		 nextPutAll: nativeError asString;
		 nextPutAll: '] Error:';
		 nextPutAll: message asString
]
