#!/usr/bin/env sh

if dmesg | grep -q "Hello World!"; then
	echo "Module correctly loaded"
else
	echo "Something went wrong!"
	exit 1
fi

# A background sleep allows to handle signals
exec /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"
