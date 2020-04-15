winLen = 60; window = ones(winLen,1);
zcr_lim = 15; ste_lim = 0.015;
fs = 8000; ds = 5;
recorder = audiorecorder(fs, 16, 1);
disp('Start speaking.')
recorder.record(ds);
unvoiced = 'r';voiced = 'g';silence = 'k';

h = figure;


winAudio = [];
while recorder.isrecording()
    pause(0.1);
    audio = recorder.getaudiodata();
    winAudio = audio;
    %x = [x (x(end)+1):(x(end)+len(audio))]; 
    audio_ste = ste(winAudio,window,winLen);
    audio_zcr = zcr(winAudio,window,winLen);
    
    for i = 1:length(audio_zcr)-1
    if audio_zcr(i) == 0   
        
        a = audio(1+(winLen*i)-winLen:(winLen*i));
        x_num =1+(winLen*i)-winLen:(winLen*i) ; 
        plot(x_num,a,'k');
        hold on
        ylim([-0.5,0.5])
        %xlim([0,400])
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
        winAudio = [];
        drawnow();
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        
    else
        a = audio(1+(winLen*i)-winLen:(winLen*i));
        x_num =1+(winLen*i)-winLen:(winLen*i) ; 
        plot(x_num,a,'green');
        ylim([-0.5,0.5])
        %xlim([0,400])
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
        winAudio = [];
        drawnow();
        
        frame = getframe(h); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256);
     end
    end
     
%     
%     elseif audio_zcr <= zcr_lim
%         plot(audio,voiced);
%         ylim([-0.5,0.5])
%         set(gca,'xtick',[])
%         set(gca,'ytick',[])
%     end
%     
%     if audio_zcr > zcr_lim
%         if audio_ste < ste_lim
%             plot(audio,voiced);
%             ylim([-0.5,0.5])
%             set(gca,'xtick',[])
%             set(gca,'ytick',[])
%         else
%             plot(audio,unvoiced);
%             ylim([-0.5,0.5])
%             set(gca,'xtick',[])
%             set(gca,'ytick',[])
%         end 
%     end
%     
%     plot(audio);
%     ylim([-0.5,0.5])
%     set(gca,'xtick',[])
%     set(gca,'ytick',[])
%     
    
end

disp('End of Recording.');
