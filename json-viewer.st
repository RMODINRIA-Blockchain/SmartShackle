| contractsLocation gethURL address instance pwd |
contractsLocation := FileLocator contractsFolder.
gethURL := 'http://localhost:8545'.
[ FogCachedConnection currentOn: gethURL.
FogCache reset.
FogFileContractDescription
	loadKnownContracts: contractsLocation
	connection: FogCachedConnection currentConnection.
FogTransactionMonitorService
	reset;
	current ]
	on: Error
	do: [ :err | 
		self halt.
		FileStream stderr
			nextPutAll: 'Error during configuration ' , err messageText.
		Smalltalk exit: 1 ].
address := Smalltalk arguments at: 2.
instance := FogConnection currentConnection findContractBindByHash: address blockTag: #latest. 

instance contract hasAst
	ifFalse: [ FileStream stderr
			nextPutAll: 'Contract instance does not match any available source code';
			cr.
		Smalltalk exit: 1 ].
FileStream stdout
	nextPutAll:
		(SmartInspect new
			instance: instance;
			yourself) json;
	cr.
^ Smalltalk exit: 0
