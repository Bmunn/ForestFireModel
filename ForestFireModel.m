function data = ForestFireModel(T,plotFF,analyseFF,PG,PL)
%FOREST FIRE MODEL
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%INPUTS:
% The main adjustable parameters are
%   1) 'T' - Number of generations simulation is ran for
%   2) 'plotFF' - Flag to plot FFM
%   3) 'analyseFF' - Flag to save each timestep for an output vector data
%   4) 'PG' - Scales the probability that a forest will grow in a cell
%       that is unoccupied.
%   5) 'PL' - Scales the probability that a forest with no burning
%       neighbors will ignite ('Lightning' rule; Drossel and Schwabl 1992)
%
%-Forest density approaches a constant of ~0.39 when ProbLight -> 0.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OUPUTS:
%Output is the 3D array 'TS' which shows the matrix for each time
%step so code can be debugged, statistics can be calculated. TS=(X,Y,T) is the
%X,Y computational domain for each time step T.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
%% Plot and analyse

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameter to adjust
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Size of grid
Dimensions=500; %Bak et al. 1990 used 256
%Probability a tree will grow from bare ground
ProbGrow=1/200; 
ProbGrow=ProbGrow*PG;
%%%%%%%%%%%%%%%%%%%%%%%%%%
%PARAMETER SET BY INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Probabiliy that a lightning strike will ignite a tree
ProbLight=ProbGrow/150; %ProbLight=0.00001*0.05; %ProbLight=0.00001;
ProbLight=ProbLight*PL;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output
%%%%%%%%%%%%%%%%%%%%%%%%%%
if analyseFF
 data = zeros(Dimensions,Dimensions,T);
else 
    data=[];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here we need to implement a random network of the 3 states 0, 1 & 2
x=floor(3.*rand(Dimensions,Dimensions));

% Meaning
%0= empty ground
%1= trees
%2= fire

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:T
    
   
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %Initialise an empty grid
    xi=x;
    x=zeros(Dimensions,Dimensions);
    %Here we want to set all burning trees to zero while saving all trees
    x(xi==1)=1;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 %We want empty ground to grow trees with probability p  
    p=rand(Dimensions,Dimensions);  
    x(xi==0 & p<ProbGrow)=1;
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Fire spreads to it's neighbouring trees in the next time step
 
%First find all active trees
    [ii,jj] = find(xi==2);
    
    %Loop through each tree
    for m=1:numel(ii)
        
        if ~ismember([ii(m); jj(m)],[1 Dimensions])
            
            %Here we want to set each of a burning trees neighbours alight
            if xi(ii(m)-1,jj(m))==1
                x(ii(m)-1,jj(m))=2;
            end
            if xi(ii(m),jj(m)+1)==1
                x(ii(m),jj(m)+1)=2;
            end
            if xi(ii(m),jj(m)-1)==1
                x(ii(m),jj(m)-1)=2;
            end
            if xi(ii(m)+1,jj(m))==1
                x(ii(m)+1,jj(m))=2;
            end
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rule 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%RULE 5 a tree becomes a burning tree with probability f if no neighbour is burning
    f=rand(Dimensions,Dimensions);
    x(xi==1 & f<ProbLight)=2;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Statistics calculated for later
    %%%%%%%%%%%%%%%%%%%%%
    %Calculate how much land is occupied by fires, bare ground and forest
    Fires=sum(sum(x==2));
    Bare=sum(sum(x==0));
    Forest=sum(sum(x==1));
    
    FRatio=100*Fires/(Dimensions*Dimensions);
    BRatio=100*Bare/(Dimensions*Dimensions);
    ForRatio=100*Forest/(Dimensions*Dimensions);
    %%%%%%%%%%%%%%%%%%%%%
    %save the computation domain
    if analyseFF
     data(:,:,t)=x;
    end
    %%%%%%%%%%%%%%%%%%%%%
    
    %If Plotting figures
    if ~mod(t,10) && plotFF
        %PLOTS
        figure(1)
        %Simulation
        %subplot(3,1,1:2)
        imagesc(x)
        colormap([1,1,1;0,1,0;1,0,0])
        h = colorbar;
        caxis([0 2])
        title( sprintf( 'ProbGrow= %f, ProbLight= %f', ProbGrow, ProbLight ) )
        set(h, 'YLim', [0 2],'YTick',0.5:0.5:1.5,'YTickLabel',{'empty','trees','fire'})
        axis square
        
        %Percentage of land occupied by each state
%        subplot(3,1,3)
%         scatter(t,FRatio,'r*')
%         hold on
%         scatter(t,ForRatio,'g*')
%         scatter(t,BRatio,'k*')
%         axis([0 T 0 100])
%         legend('Fire','Forest','Bare Ground')
%         xlabel('Time (generations)')
%         ylabel('% of Area')
          drawnow limitrate
        
    end
    
    %Exit loop if fires are extinguished
    if ProbLight==0 && Fires==0
        Error('There are no more Fires!!!')
    end
end


end 

