#!/bin/ash

# Would the _real_ ffmpeg please step forward?
REAL_FFMPEG=/bin/ffmpeg_for_realz


# What's our CPU usage?
CPU_USAGE_FP=`cat /proc/loadavg | awk '{print $1}'`
CPU_USAGE=`printf %.0f "$CPU_USAGE_FP"`

# Do we have any stats on GPU memory free?
if [ ! -f /gpu-free-ram ]
then
        # No stats, so just pass this through to the real FFMPEG
        $REAL_FFMPEG "$@"
else
        # Yes, we have stats. Now, do we have less than 1GB free GPU RAM?
        FREE_GPU_RAM=`cat /gpu-free-ram`

        # If we have more than 1.5GB RAM, then all good, carry on
        if [ "$FREE_GPU_RAM" -lt 1500 ]
        then
		# If load > 10 and we're running out of GPU RAM, then rather fail than take the whole node down
		if [ "$CPU_USAGE" -gt 20 ]
		then
			echo "GPU free RAM < 1.5GB, but system load > 20. Aborting"
			exit 1
		fi
		
                # Are we doing a HW decode?
                echo $@ | grep -q h264_cuvid

                if [ $? -eq 0 ]
                then
                        # Yes - so strip off the first 16 characters of the ffmpeg command (removing the HW decode)
                        $REAL_FFMPEG "${@:16:10000}"
                else
                        # No - proceed as normal
                        $REAL_FFMPEG "$@"
                fi
        else
                # Proceed as normal
                $REAL_FFMPEG "$@"
        fi
fi
