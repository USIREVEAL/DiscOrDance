"
I am an error that is signaled when some permissions do not match standard structure in a discord server (i.e. a channel is visible but it's messages cannot be accessed).
There may be cases where this might be a legitimate behaviour but in general this are cases worth being investigated.
"
Class {
	#name : #DDPossiblePermissionInconsistency,
	#superclass : #DDSanityCheckError,
	#category : #'DiscOrDance-Exceptions'
}
