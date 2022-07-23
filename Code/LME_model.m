% Lankinen K, Ahlfors SP, Mamashli F, Blazejewska AI, Raij T, Turpin T,
% Polimeni JR & Ahveninen J (2022):
% Cortical depth profiles of auditory and visual 7T functional MRI responses 
% in human superior temporal areas

% This script reproduces the LME model (formula (2) in the paper)

%% Depth profiles matrix: [surfaces x subjects x condition x ROIs x hemi];

load('depth_profiles.mat')

subjectnames = {'S01', 'S01', 'S02', 'S02', 'S03', 'S04', 'S04','S05', 'S06', ...
'S06', 'S07', 'S08', 'S08', 'S09', 'S10', 'S11',  'S12', 'S12', 'S13', 'S13'};
sessions = [1 2 1 2 1 1 2 1 1 2 1 1 2 1 1 1 1 2 1 2]; % Session number (corresponding 
% to the subject names above). Subjects have 1 or 2 sessions.

conditions = {'A', 'V'};        % Auditory/Visual condition
hemis={'lh', 'rh'};             % Left/Right hemisphere
pthr=0.05;                      % Statistical significance threshold 
rois={'HG', 'HS', 'PT', 'pSTG', 'mSTS','pSTS'}; % Regions of interest 
surfaces = {'00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10' }; % Surface index: '00': White matter, '10': Pial surface
xvalues = -5:5; % Centered at 0 
normal = true; % Normalization (true/false)

%% Calculate Linear mixed-effect model (formula (2)), and plot predicted values by the model

pvalues = [];

for hidx = 1:length(hemis)
  
    figure(hidx);hold on; % for A condition
    figure(hidx+2);hold on; % for V condition
    k = 1;

    for ridx = 1:length(rois)
          
        data = depth_pct(:,:,:,ridx,hidx);
      
        % Construct a struct for each model:
        lmedata.subj=[];
        lmedata.session=[];
        lmedata.surface=[];
        lmedata.cond=[];
        lmedata.pct=[];

        for sidx = 1:length(subjectnames)

            sname=subjectnames{sidx};
            sessname = ['session', num2str(sessions(sidx))];
            
            for cidx = 1:length(conditions)

                lmedata.subj=[lmedata.subj;repmat(sname,length(surfaces),1)];
                lmedata.session=[lmedata.session;repmat(sessname,length(surfaces),1)];               
                lmedata.cond=[lmedata.cond;repmat(conditions{cidx},length(surfaces),1)];
                lmedata.surface=[lmedata.surface;xvalues'];
                lmedata.pct=[lmedata.pct;data(:,sidx,cidx)];

            end
        end
        
        lmedata.surface2=lmedata.surface.^2; % add quadratic term

        if normal == true
            Aind=ismember(lmedata.cond,'A','rows');
            Vind=ismember(lmedata.cond,'V','rows');
            lmedata.pct(Aind)=normalize(lmedata.pct(Aind));
            lmedata.pct(Vind)=normalize(lmedata.pct(Vind));
        end

        mdata=struct2table(lmedata);
        
        % Fit a linear mixed-effect model with fixed effects for condition,
        % surface, surface^2, condition*surface, condition*surface^2, and
        % random effectd for (1|subj) and (1|subj:session):
        outputmdl=fitlme(mdata,'pct ~ 1 + cond + surface + surface2 + cond*surface + cond*surface2 + (1|subj) + (1|subj:session)');
    
        % Print model output:
        outputmdl

        % Save p-values:
        pvalues(:,ridx, hidx) = outputmdl.Coefficients(:,6);
        
        % Use the function "fitted" to get predicted values, which can be
        % summarized to plot means and standard error of means 
         
        clear predtable
        predtable.cond = mdata.cond;
        predtable.pct = mdata.pct;
        predtable.surface = mdata.surface;
        predtable.surface2 = mdata.surface2;
        predtable.pred = fitted(outputmdl);
        predstruct = struct2table(predtable);

        % Calculate group statistics (mean and sem):
        T= grpstats(predstruct,{'cond', 'surface', 'surface2'}, {'mean', 'sem'});

        % Find indices for A and V conditions:
        Aind = 1:(size(T,1)/2);
        Vind = (size(T,1)/2 + 1) : size(T,1); 

        % Plot the predicted depth profiles for A and V conditions:
        figure(hidx);hold on;
        subplot(2,3,k),
        errorbar(1:length(surfaces),T.mean_pct(Aind), T.sem_pct(Aind), 'b', 'LineStyle', 'None');hold on
        plot(1:length(surfaces), T.mean_pct(Aind), 'bo', 'Markersize', 3.5, 'MarkerFaceColor', 'b');hold on;         
        plot(1:length(surfaces), T.mean_pred(Aind), 'b-', 'LineWidth', 1.5); 
        xlim([1 11])
        xlabel('surface wm --> gm')
        ylabel('%-signal change')
        set(gca,'TickDir','out');
        titletext=[rois{ridx} , ' ',  hemis{hidx}];
        titletext(findstr('_',titletext))=' ';
        title({titletext});
        sgtitle('Predicted, condition A')
        set(gcf, 'color', 'white')
        
        
        figure(hidx+2);hold on;
        subplot(2,3,k),
        errorbar(1:length(surfaces),T.mean_pct(Vind), T.sem_pct(Vind), 'r', 'LineStyle', 'None');hold on
        plot(1:length(surfaces), T.mean_pct(Vind), 'ro', 'Markersize', 3.5, 'MarkerFaceColor', 'r');hold on;         
        plot(1:length(surfaces), T.mean_pred(Vind), 'r-', 'LineWidth', 1.5);        
        xlim([1 11])
        xlabel('surface wm --> gm')
        ylabel('%-signal change')
        set(gca,'TickDir','out');
        titletext=[rois{ridx} , ' ',  hemis{hidx}];
        titletext(findstr('_',titletext))=' ';
        title({titletext});
        sgtitle('Predicted, condition V') 
        set(gcf, 'color', 'white')
      
        k = k + 1;
        
    end 
end

%% Format the p-values matrix as in manuscript Table S1:

clear pvals_formatted
pvals_formatted(:,[1,3,5,7,9,11]) = pvalues(:,:,1);
pvals_formatted(:,[2,4,6,8,10,12]) = pvalues(:,:,2);

% Calculate FDR corrected p-values (Benjamin & Hochberg 1995)
fdrval = mafdr(pvals_formatted(:), 'BHFDR', true);
pvals_formatted = reshape(fdrval,6,12);

pvals_formatted([2 3],:) = pvals_formatted([3 2],:); % move surface after condition for readability


