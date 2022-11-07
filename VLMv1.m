%{
VLM v1
11/6/2022
Supports 2D planform geometries at various AOA, no sideslip, inviscid
dependencies:
    wingGeom2D()
    VLMSOLVE2D()
    BSL()
    vlinspace()
    cfigure()
%}
%%
clc
clear
close all
format compact
format shortg
%%
% define geometry & discretization
    % for one section wing:
    % data = [rootC,b/2,offset,bPanels;
    %         tipC,~,offset,~]
    % for multi section wing:
    % data = [rootC,b/2,offset,bPanels;
    %         intermediateC,b/2,offset,bPanels
    %         tipC,~,offset,~]
data = [1.2,1,0,5;
    .7,3,.5,10;
    .2,NaN,1.7,NaN];
cPanels = 6;
b = 2*sum(data(1:end-1,2));
bPanels = 2*sum(data(1:end-1,4));
nPanels = cPanels*bPanels;
U_inf = 1; 
alpha = 10*pi/180;

% solve! 
[wingGeomX,wingGeomY,panelRX,panelRY,panelTX,panelTY,panelCPX,panelCPY,K] = wingGeom2D(data,cPanels);
Gamma = VLMSOLVE2D(panelRX,panelRY,panelTX,panelTY,panelCPX,panelCPY,U_inf,alpha);

%
x = linspace(-5,15,40);
y = linspace(-4,4,20);
z = y;
[X,Y,Z] = meshgrid(x,y,z);

U=U_inf*cos(alpha)*ones(size(X));
V=zeros(size(X));
W=U_inf*sin(alpha)*ones(size(X));

% % fake visualization (will fix later)
% for p = 1:nPanels
%     [Ubi,Vbi,Wbi]=BSL(X-panelRX(p),Y-panelRY(p),Z,X-panelTX(p),Y-panelTY(p),Z,Gamma(p));
%     [Utri,Vtri,Wtri]=BSL(X-(panelRX(p)+4000),Y-panelRY(p),Z,X-panelRX(p),Y-panelRY(p),Z,Gamma(p));
%     [Utti,Vtti,Wtti]=BSL(X-panelTX(p),Y-panelTY(p),Z,X-(panelTX(p)+4000),Y-panelTY(p),Z,Gamma(p));
%     U = U + Ubi + Utri + Utti;
%     V = V + Vbi + Vtri + Vtti;
%     W = W + Wbi + Wtri + Wtti;
% end
% cfigure([.5,.5])
% hold on
% surf(wingGeomX,wingGeomY,zeros(size(wingGeomY)),'FaceColor','none','Displayname','Wing Geometry')
% streamline(X,Y,Z,U,V,W,wingGeomX(end,:),wingGeomY(end,:),zeros(1,bPanels+1))
% axis equal, axis tight