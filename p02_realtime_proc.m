global BufferDaqSignal

length_buffer = 3; %s
Fs = 10000;
num_ch = 3;
BufferDaqSignal = zeros(length_buffer*Fs,num_ch);

figure;
l = plot(BufferDaqSignal(1:10:end,end),'LineWidth',2,'Color','k');

return;
%% refleshloop
while 1 == 1
    global BufferDaqSignal
    l.YData = BufferDaqSignal(1:10:end,end);
    drawnow limitrate
    pause(0.03);
end