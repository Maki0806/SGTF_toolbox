%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo1: Spectral graph trilateral filter (SGTF) by using the specific
%               parameter, i.e., the parameter optimization is not perfomed.
% Note:Our code requires the graph signal processing tool box (GSPBox).
%          You must donwonload the tool box at https://lts2.epfl.ch/gsp/
%          and place it into the SGTF tool box.
%
% Author: Masaki Onuki (masaki.o@msp-lab.org)
% Last version: May 31, 2016
% Article: M. Onuki, S. Ono, M. Yamagishi, Y. Tanaka,
% "Graph Signal Denoising via Trilateral Filter on Graph Spectral Domain,"
% IEEE Transactions on Signal and Information Processing over Networks, vol. 2, no. 2, pp. 137-148, June 2016.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('all_paths', 'var')
    path(all_paths);
end

clearvars
close all
addpath gspbox

gsp_start();

all_paths = path;

%%%%%%%%%%%%%%%%%%%%% User Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----The used graph is selected----
    Used_graph = 'swiss_roll';
%     Used_graph = 'minnesota';
%     Used_graph = '3Dmesh';
    
%----Noise variance----
sigma = 20;

   disp('============================================================')
 %%%%%%%%%%%%%%%%%%%%%Some denoising examples%%%%%%%%%%%%%%%%%%%%%%%  
if strcmp(Used_graph, 'swiss_roll')
    path(all_paths,'SGTF_functions/SGTF_for_graph_signals');
    disp('------------------------------Swiss roll graph smoothing------------------------------')
    
    %----the number of nodes----
    npoints = 2642;
    
    %----Swiss roll graph is created----
    [G]=gsp_swiss_roll(npoints);
     G.plotting.cp = [0.25, -0.91, 0.3];
    
    %----Graph signals are defined----
    C = G.coords;
    for i=1:npoints
        if C(i,1)>-0.35 && C(i,3)>-0.4 && C(i,1)<0.5
            x_star(i)=200;
        elseif C(i,1)<=-0.35
            x_star(i)=100;
        elseif C(i,1)>-0.35 && C(i,3)<-0.4
            x_star(i)=50;
        elseif C(i,1)>0.5 && C(i,3)>=-0.4
            x_star(i)=-0;
        end
    end
    
    %----Noisy signal is created----
    Load_noisy_graph = sprintf('%s_sigma_%d.mat',Used_graph,sigma);
    if exist(Load_noisy_graph,'file')
        load(Load_noisy_graph);
    else
        Err_msg = sprintf('Error: The noisy signal (sigma = %d) is not prepared in the case of swiss roll. There were only the noisy signals sigma = 20, 30, 40, 50. Please, change sigma!', sigma);
        error(Err_msg);
        return;
    end
    
    %----SGTF for Swiss roll graph----
    [x_rho_opt,x_rho_non_opt,SNR_opt,SNR_not_opt,SNR_noise]=SGTF_graph_signal_denosing_once(G,y,x_star);
    path(all_paths);
elseif strcmp(Used_graph, 'minnesota')
    path(all_paths,'SGTF_functions/SGTF_for_graph_signals');
    disp('------------------------------Minnesota graph smoothing------------------------------')
    
    %----Minnesota graph is created----
    [G] = gsp_minnesota();
    
    %----Graph signals are loaded----
    load min_graph_signal
    
    %----Noisy signal is created----
    sigma_string = sprintf(num2str(1000*sigma,4));
    Load_noisy_graph = sprintf('%s_sigma_%s.mat',Used_graph,sigma_string);
    if exist(Load_noisy_graph,'file')
        load(Load_noisy_graph);
    else
        Err_msg = sprintf('Error: The noisy signal (sigma = %d) is not prepared in the case of minnesota. There were only the noisy signals with sigma = 1/8, 1/4, 1/2, 1. Please, change sigma!', sigma);
        error(Err_msg);
        return;
    end
    
    %----SGTF for Minessota graph----
    [x_rho_opt,x_rho_non_opt,SNR_opt,SNR_not_opt,SNR_noise]=SGTF_graph_signal_denosing_once(G,y,x_star);
    path(all_paths);
elseif strcmp(Used_graph, '3Dmesh')
    path(all_paths,'SGTF_functions/SGTF_for_threeD_mesh');
    disp('------------------------------3D mesh (teapot) smoothing------------------------------')
    
    %----3D mesh is created----
    [p_star,W,tri]=mesh2graph(100);
    
    %----Graph signals are defined----
    Load_noisy_graph = sprintf('%s_sigma_%d.mat',Used_graph,sigma);
    if exist(Load_noisy_graph,'file')
        load(Load_noisy_graph);
    else
        Err_msg = sprintf('Error: The noisy signal (sigma = %d) is not prepared in the case of 3D mesh. There were only the noisy meshes with sigma = 20, 30, 40, 50. Please, change sigma!', sigma);
        error(Err_msg);
        return;
    end
    
    %----SGTF for 3D mesh----
    [SNR_SGTF,SNR_SGTF_not_opt,SNR_Noise,p_rho_opt,p_rho_not_opt]=SGTF_threeD_mesh_once(p,p_star,W);
    path(all_paths);
end

 %%%%%%%%%%%%%%%%%%%%Representation of the results%%%%%%%%%%%%%%%%%%%%%% 
 disp('------------------------------Results------------------------------')
if strcmp(Used_graph, 'swiss_roll') || strcmp(Used_graph, 'minnesota')
    figure
    subplot(2,2,1)
    gsp_plot_signal(G,x_star)
    title('Original graph signal')
    
    subplot(2,2,2)
    gsp_plot_signal(G,y.y)
    title('Noisy graph signal')
    
    subplot(2,2,3)
    gsp_plot_signal(G,x_rho_opt)
    title('SGTF with optimization')
    
    subplot(2,2,4)
    gsp_plot_signal(G,x_rho_non_opt)
    title('SGTF without optimization')
    
    disp(['SNR(with optimized_rho) =',num2str(SNR_opt,4),', SNR(unoptimization) =',num2str(SNR_not_opt,4)])
    disp(['SNR(noissy signal) =',num2str(SNR_noise,4)])
elseif strcmp(Used_graph, '3Dmesh')
    figure
    subplot(2,2,1)
    trisurf(tri, p_star(:,1), p_star(:,2), p_star(:,3))
    axis equal, axis tight, view(20,20)
    colorbar('off')
    title('Original mesh')
    
    subplot(2,2,2)
    trisurf(tri, p.p(:,1), p.p(:,2), p.p(:,3))
    axis equal, axis tight, view(20,20)
    colorbar('off')
    title('Noisy mesh')
    
    subplot(2,2,3)
    trisurf(tri, p_rho_opt(:,1), p_rho_opt(:,2), p_rho_opt(:,3))
    axis equal, axis tight, view(20,20)
    colorbar('off')
    title('SGTF with optimization')
    
    subplot(2,2,4)
    trisurf(tri, p_rho_not_opt(:,1), p_rho_not_opt(:,2),p_rho_not_opt(:,3))
    axis equal, axis tight, view(20,20)
    colorbar('off')
    title('SGTF withtout optimization')
    
    disp(['SNR(with optimized_rho) =',num2str(SNR_SGTF,4),', SNR(unoptimization) =',num2str(SNR_SGTF_not_opt,4)])
    disp(['SNR(noissy signal) =',num2str(SNR_Noise,4)])
end

