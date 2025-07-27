function record_sc
    set vid_file ~/Desktop/vid_(date +%s).mp4
    set aud_file ~/Desktop/aud_(date +%s).wav
    
    # Start recording
    wf-recorder -f $vid_file -g "2560x1440" &
    ffmpeg -f pulse -i "alsa_output.pci-0000_00_1f.3.analog-stereo.monitor" \
      -af "afftdn=nf=-25" $aud_file &
    
    echo "Recording started... Press Enter to stop"
    read
    
    # Stop processes
    pkill -INT wf-recorder
    pkill ffmpeg
    sleep 1
    
    # Merge with adjusted volume
    ffmpeg -i $vid_file -i $aud_file \
      -c:v copy -c:a aac -af "volume=1.2" \
      ~/Desktop/clean_recording_(date +%s).mp4
    
    rm $vid_file $aud_file
    echo "✅ Clean recording saved!"
end
