load('wioioi01','yp','fs');

% Determine formant track and pitch track and plot it
[formant_tracks,pitch_track] = ftrack(yp,fs);

% just to plot it on the same page
figure;
h1 = plot(formant_tracks);
hold on;
h2 = plot(10*pitch_track,'y.-');
legend([h1;h2],'F1','F2','F3','10*F0')