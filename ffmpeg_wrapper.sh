#!/bin/ash

# Would the _real_ ffmpeg please step forward?
REAL_FFMPEG=/bin/ffmpeg_for_realz

# Do we have any stats on GPU memory free?
if [ ! -f /gpu-free-ram ]
then
	# No stats, so just pass this through to the real FFMPEG
	$REAL_FFMPEG "$@"
else
	# Yes, we have stats. Now, do we have less than 1GB free GPU RAM?
	FREE_GPU_RAM=`cat /gpu-free-ram`

	# If we have more than 1GB RAM, then all good, carry on
	if [ "$FREE_GPU_RAM" -gt 1024 ]
	then
		$REAL_FFMPEG "$@"
	else
		# Too dangerous, bail, emby can do a CPU transcode instead
		echo "GPU RAM too low, likely that we'll get an X31 crash. Aborting."
		exit 1
	fi
fi

