clc;
clear all;
close all;

%%
load('RIR\ANG90.mat');
h=RIR_cell{1};
RT_schroeder_nofitting(reshape(h,1,length(h)),16000,1,1,1);