function [wingGeomX,wingGeomY,panelRX,panelRY,panelTX,panelTY,panelCPX,panelCPY,K] = wingGeom2D(data,cPanels)
% last updated: 11/7/2022
% formatting: 
%   for one section wing:
%   data = [rootC,b/2,offset,bPanels;
%            tipC,~,~,~]
%   for multi section wing:
%   data = [rootC,b/2,offset,bPanels;
%           intermediateC,b/2,offset,bPanels
%           tipC,~,~,~]
% cpanels = # of chordwise panels
%   dependencies:
%   cfigure()
%   BSL()
%   vlinspace()

%     b = 2*sum(data(1:end-1,2));
    bPanels = sum(data(1:end-1,4));
    wingGeomY = zeros(1,bPanels+1);
    wingGeomX = zeros(cPanels+1,bPanels+1);
    m = 1;
    for i = 1:(size(data,1)-1)
        wingGeomY(m:m+data(i,4)) = linspace(sum(data(1:i-1,2)),sum(data(1:i,2)),data(i,4)+1);
        wingGeomX(:,m:m+data(i,4)) = vlinspace(linspace(data(i,3),data(i,1)+data(i,3),cPanels+1)',linspace(data(i+1,3),data(i+1,1)+data(i+1,3),cPanels+1)',data(i,4)+1);
        m = m + data(1,4);
    end
    wingGeomY = repmat([-flip(wingGeomY,2),wingGeomY(:,2:end)],cPanels+1,1);
    wingGeomX = [flip(wingGeomX,2),wingGeomX(:,2:end)];

    panelRX = .75*wingGeomX(1:end-1,1:end-1)+.25*wingGeomX(2:end,1:end-1);
    panelRY = wingGeomY(1:end-1,1:end-1);
    panelTX = .75*wingGeomX(1:end-1,2:end)+.25*wingGeomX(2:end,2:end);
    panelTY = wingGeomY(1:end-1,2:end);
    K = sqrt((panelTX-panelRX).^2+(panelTY-panelRY).^2);
    panelCPY = (wingGeomY(1:end-1,1:end-1)+wingGeomY(1:end-1,2:end))*.5;
    panelCPX = (.25*wingGeomX(1:end-1,1:end-1)+.75*wingGeomX(2:end,1:end-1)+.25*wingGeomX(1:end-1,2:end)+.75*wingGeomX(2:end,2:end))*.5;
    
    cfigure([.5,.5])
    hold on
    surf(wingGeomX,wingGeomY,zeros(size(wingGeomY)),'FaceColor','none','Displayname','Wing Geometry')
    scatter3(reshape(panelCPX,[],1),reshape(panelCPY,[],1),reshape(zeros(size(panelCPX)),[],1),'vb','DisplayName','Collocation Points')
    scatter3(reshape(panelRX,[],1),reshape(panelRY,[],1),reshape(zeros(size(panelRX)),[],1),'xr','Displayname','Vortex Filament Root')
    scatter3(reshape(panelTX,[],1),reshape(panelTY,[],1),reshape(zeros(size(panelTX)),[],1),'or','Displayname','Vortex Filament Root')
    legend
    view([90,90])
    axis equal
    axis tight
    xlabel('x'),ylabel('y'),zlabel('z')
end