FROM       emby/embyserver:beta

RUN cp /bin/ffmpeg /bin/ffmpeg_for_realz
COPY ffmpeg_wrapper.sh /bin/ffmpeg
RUN chmod 755 /bin/ffmpeg
