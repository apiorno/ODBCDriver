"
A result table 
"
Class {
	#name : #ODBCResultTable,
	#superclass : #OrderedCollection,
	#instVars : [
		'columns',
		'preferredColumnWidths',
		'extraLinkBlock',
		'extraLinkTitle',
		'columnPrintBlock'
	],
	#category : #'ODBC-Model-Definitions'
}

{ #category : #formatting }
ODBCResultTable class >> formatItem: aString toWidth: aNumber [

	^ aString
		padded: #right 
		to: aNumber
		with: $ 
]

{ #category : #'instance creation' }
ODBCResultTable class >> new [

	^ super new initialize
]

{ #category : #'instance creation' }
ODBCResultTable class >> newFrom: anODBCResultSet [ 
	| table |
	table := self new.
	table columns: anODBCResultSet columns.
	anODBCResultSet do: [ :each | table add: each ].
	anODBCResultSet close.
	^ table
]

{ #category : #adding }
ODBCResultTable >> add: row [ 
	self maxWidthOfColumnsForRow: row.
	^ super add: row
]

{ #category : #converting }
ODBCResultTable >> asMorph [
	| twoWayScroller report title window |
	report := TextMorph new
		backgroundColor: Color transparent;
		borderWidth: 0;
		margins: 6;
		beAllFont: (StrikeFont 
				familyName: #BitstreamVeraSansMono
				size: 12);
		contents: (Text streamContents: [ :stream | self printTextOn: stream ]).
	twoWayScroller := ScrollPane new
		borderWidth: 0;
		setScrollDeltas.
	twoWayScroller scroller addMorph: report.
	title := String streamContents: 
		[ :stream | 
		stream
			nextPutAll: 'Query Results (';
			nextPutAll: self size asString , ' row'.
		self size ~= 1 ifTrue: [ stream nextPut: $s ].
		stream nextPut: $) ].
	window := (SystemWindow labelled: title) paneColor: (Color 
			r: 1.0
			g: 0.903
			b: 0.258).
	window extent: 700 @ 400.
	window position: (Display extent - window extent) // 2.
	^ window 
		addMorph: twoWayScroller
		fullFrame: (LayoutFrame fractions: (0 @ 0 extent: 1 @ 1))
]

{ #category : #accessing }
ODBCResultTable >> columnNames [
	^ self columns collect: [ :each | each name ]
]

{ #category : #accessing }
ODBCResultTable >> columnPrintBlock [
	^ columnPrintBlock ifNil: [ self standardColumnPrintBlock ]
]

{ #category : #accessing }
ODBCResultTable >> columnPrintBlock: aThreeArgBlock [ 
	columnPrintBlock := aThreeArgBlock
]

{ #category : #accessing }
ODBCResultTable >> columns [
	^ columns
]

{ #category : #accessing }
ODBCResultTable >> columns: aList [ 
	columns := aList reject: 
		[ :each | 
		#(
			#DBConnect
			#DBName
			#DatabaseName
			#ImportVersion
			#Locked
		) includes: each name ]
]

{ #category : #accessing }
ODBCResultTable >> extraLinkTitle: aString do: aOneArgumentBlock [ 
	extraLinkTitle := aString.
	extraLinkBlock := aOneArgumentBlock
]

{ #category : #initialization }
ODBCResultTable >> initialize [
	preferredColumnWidths := Dictionary new
]

{ #category : #accessing }
ODBCResultTable >> maxWidthOfColumn: anODBCColumn [ 
	^ (preferredColumnWidths at: anODBCColumn) + 2
]

{ #category : #accessing }
ODBCResultTable >> maxWidthOfColumnsForRow: row [ 
	self columns do: 
		[ :each | 
		| currentWidth |
		currentWidth := preferredColumnWidths 
			at: each
			ifAbsentPut: [ each name size ].
		preferredColumnWidths 
			at: each
			put: (currentWidth max: (row at: each name) printString size) ]
]

{ #category : #converting }
ODBCResultTable >> openAsMorph [
	self asMorph openInWorld
]

{ #category : #accessing }
ODBCResultTable >> preferredColumnWidths [
	"Return a list of associations so that column order is preserved"
	^ self columns collect: [ :each | each -> (self maxWidthOfColumn: each) ]
]

{ #category : #printing }
ODBCResultTable >> printHeaderOn: aStream [ 
	self columns do: 
		[ :each | 
		| columnHeader |
		columnHeader := self class 
			formatItem: each name
			toWidth: (self maxWidthOfColumn: each).
		aStream nextPutAll: columnHeader ].
	aStream cr.
	self columns do: 
		[ :each | 
		aStream
			nextPutAll: (String 
					new: (self maxWidthOfColumn: each) - 1
					withAll: $-);
			nextPut: $  ].
	aStream cr
]

{ #category : #printing }
ODBCResultTable >> printOn: aStream [ 
	self printHeaderOn: aStream.
	self do: 
		[ :each | 
		each 
			printOn: aStream
			withColumnDefinitions: self preferredColumnWidths.
		aStream cr ]
]

{ #category : #printing }
ODBCResultTable >> printTextForRow: aRow on: aTextStream [ 
	self preferredColumnWidths do: 
		[ :each | 
		self columnPrintBlock 
			value: aRow
			value: each
			value: aTextStream ].
	extraLinkTitle ifNotNil: 
		[ aTextStream 
			withAttribute: (PluggableTextAttribute evalBlock: [ extraLinkBlock value: aRow ])
			do: [ aTextStream nextPutAll: extraLinkTitle ] ].
	aTextStream
		space;
		cr
]

{ #category : #printing }
ODBCResultTable >> printTextOn: aTextStream [ 
	self printHeaderOn: aTextStream.
	self do: 
		[ :each | 
		self 
			printTextForRow: each
			on: aTextStream ]
]

{ #category : #private }
ODBCResultTable >> species [
	^ OrderedCollection
]

{ #category : #accessing }
ODBCResultTable >> standardColumnPrintBlock [
	^ 
	[ :row :column :textStream | 
	| columnValue |
	columnValue := row at: column key name.
	columnValue isFraction ifTrue: [ columnValue := columnValue asFloat ].
	textStream nextPutAll: (self class 
			formatItem: columnValue asString
			toWidth: column value) ]
]
