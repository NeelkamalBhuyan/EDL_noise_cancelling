C_s = C(1i*freqs);
G_s = 10.^(G_s_mag./20).*exp(1i.*2.*pi.*g_s_phase/360);
closed_tf_noise = (G_s)./(1 + C_s.*G_s);
closed_tf_v = (C_s.*G_s)./(1 + C_s.*G_s);

Open_loop_mag = 20*log10(abs(C_s.*G_s));
Open_loop_ph = angle(C_s.*G_s);
figure;
subplot(2,1,1);
semilogx(freqs/(2*pi), Open_loop_mag)
yline(0);
title('OL mag');
xlabel("Frequency (Hz)");
ylabel("Magnitude (dB)");
subplot(2,1,2); 
semilogx(freqs/(2*pi), 180/pi*Open_loop_ph)
yline(-180);
xlabel("Frequency (Hz)");
ylabel("Phase (deg)");
title('OL phase');

CL_noise_mag = 20*log10(abs(closed_tf_noise));
CL_music_mag = 20*log10(abs(closed_tf_v));

figure;
subplot(2,1,1);
semilogx(freqs/(2*pi), CL_noise_mag)
yline(0);
title('CL noise mag');
xlabel("Frequency (Hz)");
ylabel("Magnitude (dB)");
subplot(2,1,2); 
semilogx(freqs/(2*pi), CL_music_mag)
yline(0);
xlabel("Frequency (Hz)");
ylabel("Magnitude (dB)");
title('CL music mag');

function val = C(w)
    % band reject filter params
    Q1 = 0.05;
    Q2 = 1; 
    
    lag1 = ((5/50)*(w+5000)./(w+500)).^2;
    % for pushing gain cross-over freq to left while not affecting phase
    % cross over freq
    band_reject = (5*(w.^2 + w*100*2*pi*Q2 + (100*2*pi)^2)./(w.^2 + w*100*2*pi*Q1 +(100*2*pi)^2));
    % band reject filter at 100 Hz, C is Q2/Q1 at 100Hz
    lag2 = (((50/100)*(w+100*2*pi)./(w+50*2*pi)).^2);
    % Lag compensator needs to be used to push down
    % the magnitude at omega_pcf so as to have a decent enough gain margin
    % which means magnitude at omega_pcf should be negative in dB
    % Using region in 50-100Hz for pole-zero placement of lag compensator
    % as that region anyways has phase value > 0, so the dip created in
    % phase plot by the lag compensator can be placed in this region
    % without affecting phase cross-over freq at 1400 Hz
    
    val = lag2.*band_reject.*lag1;
                                                            % 
end