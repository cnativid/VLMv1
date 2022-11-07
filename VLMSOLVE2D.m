function Gamma = VLMSOLVE2D(panelRX,panelRY,panelTX,panelTY,panelCPX,panelCPY,U_inf,alpha)
    nPanels = numel(panelCPX);
    W=zeros(nPanels);
    for p = 1:nPanels
        [~,~,Wzb]=BSL(panelCPX(p)-panelRX,panelCPY(p)-panelRY,zeros(size(panelRY)),panelCPX(p)-panelTX,panelCPY(p)-panelTY,zeros(size(panelRY)),1);
        [~,~,Wzrt]=BSL(panelCPX(p)-(panelRX+4000),panelCPY(p)-panelRY,zeros(size(panelRY)),panelCPX(p)-panelRX,panelCPY(p)-panelRY,zeros(size(panelRY)),1);
        [~,~,Wztt]=BSL(panelCPX(p)-panelTX,panelCPY(p)-panelTY,zeros(size(panelRY)),panelCPX(p)-(panelTX+4000),panelCPY(p)-panelTY,zeros(size(panelRY)),1);
        W(p,:) = reshape(Wzb+Wzrt+Wztt,1,[]);
    end
    Gamma = reshape(linsolve(W,-ones(nPanels,1)*U_inf*sin(alpha)),size(panelRX));
end