function [RT,EDC_log,t_EDC] = RT_schroeder_nofitting(h,fs,plot_on,delay_comp, fig)
%--------------------------------------------------------------------------
% Modified by Bo Wu
%Measuring the Reverberation Time using the Schroeder Method without fitting
%--------------------------------------------------------------------------
%
% Input:      h:  inpulse response
%                fs: sampling frequency in [Hz]
%         Optional:      
%                plot_on:   plots the detection mechanism
%                                 0: no plot (default), 1: plot
%                delay_comp: 0: no delay compensation (default)
%                                1: compensate sound propagation delay
%                fig : figure handle for plot (default = 1)
%
% Output:     RT: reveberation time in [s]
%             EDC_log: energy decay curve (log normalized)
%             t_EDC: time vector for EDC curve
%--------------------------------------------------------------------------
%
% Copyright (c) 2012, Marco Jeub and Heinrich Loellmann
% Institute of Communication Systems and Data Processing
% RWTH Aachen University, Germany
% Contact information: jeub@ind.rwth-aachen.de
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the RWTH Aachen University nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%--------------------------------------------------------------------------

if nargin <5, fig = 1; end
if nargin < 4, delay_comp = 0; end
if nargin < 3, plot_on = 0; end
if nargin < 2; error('at least the RIR and its sampling frequency must be given');end;
%--------------------------------------------------------------------------

h_length=length(h);
%--------------------------------------------------------------------------
% Compensate sound propagation
% (exclude parts of the RIR before the direct path)
%--------------------------------------------------------------------------
% 
if delay_comp == 1
    [~,prop_delay]=max(h);
    h(1:h_length-prop_delay+1)=h(prop_delay:h_length);
    h_length=length(h);
end

%--------------------------------------------------------------------------
% Energy decay curve
%--------------------------------------------------------------------------
h_sq=h.^2;
h_sq = fliplr(h_sq);
EDC = cumsum(h_sq);
EDC = fliplr(EDC);

% normalize to '1'
EDC_norm=EDC./max(EDC);
EDC_log=10*log10(EDC_norm);
prop = find(EDC_log<=-60, 1, 'first');
RT=prop/fs;
%--------------------------------------------------------------------------
% Optional Plots
%--------------------------------------------------------------------------
t_EDC=linspace(0,h_length/fs,h_length);
if plot_on == 1
    linewidth = 2;
    fontsize = 14;
    
    figure(fig)
    clf
    plot(t_EDC,EDC_log,'LineWidth',linewidth);hold on;
    line( [0 prop/fs*1.5],[-60 -60],'Color','black','LineStyle','--','LineWidth',linewidth);
    axis([0 prop/fs*1.5 -80 0]);
    set(gca,'fontsize',fontsize)
    xlabel('Time in (s)','FontSize',fontsize);ylabel('Energy Decay in (dB)','FontSize',fontsize);title('Reverberation time estimation - Schroeder method','FontSize',fontsize);
    text(.6*RT ,-10,['T_6_0 (s) = ',num2str(RT)],'FontSize',fontsize,'color','k');
   
end
%--------------------------------------------------------------------------