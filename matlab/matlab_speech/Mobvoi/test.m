N_samp = 64;
ham_win = hamming(N_samp);
HAM_WIN = fft(ham_win);
plot(abs(HAM_WIN));
%plot(10*log10(abs(HAM_WIN)));