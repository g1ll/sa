%Algoritmo de Otimização Simulated Annealing 
function opt = sa(fo,L,U)
  D = length(L);                %Dimensão do problema (número de variáveis)
  T0 = 100                      %Temperatura Inicial
  R = 0;                        %Reannealing 0 = off 1 = on
  RT = 0.9                      %Taxa de Reduçao da Temperatura
  N = 1                         %Numero de simulaçoes por nivel de temperatura
  Iter = 100                    %Numero de iteraçoes sem mudança no otimo
  cIter = 1                     %Contador de Iteraçoes
  rc=0;
  clc
  format free
  more off
  randn('seed',10);
  rand('seed',10);
  
  fprintf('\nRestrições\n');
  L 
  U
  fprintf('\nDimensão:\n');
  D
  
  fprintf('\nTemperatura Inicial:\n');
  T0
  T=T0;
  dataPlot = [];
  
  fprintf('\nSolução Inicial:\n');
  for j = 1:D
    x0(j) = normrnd((U(j)-L(j))/2+(L(j)),rand()*((U(j)-L(j))/2)*T);
    if(x0(j)>U(j))
      x0(j)=U(j);
    elseif(x0(j)<L(j))
      x0(j)=L(j);
    end
  end
  x0
  opt = x0;
  x = x0;
  do
    for n = 1:N
      for j = 1:D
        x(j) = normrnd(x0(j),rand()*((U(j)-L(j))/2)*T);
        if(x(j)>U(j))
          x(j)=U(j);
        elseif(x(j)<L(j))
          x(j)=L(j);
        end
      end
      dE = fo(x)-fo(x0);
      if(dE<0)
        x0=x;
        if(fo(x0)<fo(opt))
           opt = x0;
        end
      else
        if(rand()<exp(-dE/T))
          x0=x;
        end
      end
      
      fprintf('\n-----------------------------:\n');
      fprintf('\nSolucao Otima Local:\n');
      x0
      fprintf('\nValor Otimo:\n')
      fo(x0)
      
      %salvando dados
      if isempty(dataPlot)
        dataPlot = [fo(x),fo(x0),fo(opt),T];
      else
        dataPlot = [dataPlot; fo(x),fo(x0),fo(opt),T];
      end
  
    end
    fprintf('\n-----------------------------:\n');
    fprintf('\nSolucao Otima:\n');
    opt
    fprintf('\nValor Otimo:\n')
    fo(opt)
    fprintf('\n-----------------------------:\n');
    fprintf('\nNova Temperatura:\n');
    %T = T*RT %Classical 0.9 
    %T = T*0.75 %Fast
    %T = T*0.95 %Exponential
    %T = T0/log(cIter)  %Botlzman
    %BotlzExp
    %init_temp(tc)*0.95^((k(tc)-nk(tc))-init_temp(tc)*0.5);
    Te = T0*0.95^((cIter-rc)-(T0/2)) %Exponential
    Tb = T0/log((cIter-rc))  %BotlzExp
    if(Te<Tb)
      T = Te;
    else
     T = Tb;
    end
    if(T<0.9 && R)
      fprintf('\nReannealing:\n');
      T=T0;
      rc = cIter;
    end
    fprintf('\nIteraçao:\n');
    cIter
    cIter++;
    
    %dataPlot
    %plotando
    xp = 1:1:length(dataPlot(:,1));    
    [zx,zy] = meshgrid(min(L):1:max(U));
    
    %fo1
    %z = zx.^2+zy.^2;
    
    %holder
    %z = -abs((sin(zx).*cos(zy)).*(exp(abs(1 - sqrt(zx.^2+zy.^2)/pi))));
    
    %egg
    z = -(zy+47) .* sin(sqrt(abs(zy+zx/2+47))) -zx .* sin(sqrt(abs(zx-(zy+47))));
   
    
    
    figure(1);
    plot( xp,dataPlot(:,1)','linestyle','none','marker','.','markersize',20,'markerfacecolor',[0,0,1],
          xp,dataPlot(:,2)','linestyle',':','linewidth',5,'marker','.','markersize',15,'markerfacecolor',[0,1,0.5],
          xp,dataPlot(:,3)','linestyle','none','marker','.','markersize',10,'markerfacecolor',[1,0,0]);
    set(gca, 'linewidth', 3, 'fontsize', 24);
    
    figure(2);
    plot(xp,dataPlot(:,4)','r-','lineWidth', 5);
    ylim([0 200]);
    
    figure(3)
    surf(zx,zy,z);
    set(gca, 'linewidth', 10, 'fontsize', 24);    
    text(opt(1),opt(2),fo(opt),'\leftarrow opt','HorizontalAlignment','left','FontWeight','bold','Color','r','fontsize', 24);
    text(x0(1),x0(2),fo(x0),'\leftarrow X0','HorizontalAlignment','left','FontWeight','bold','Color','g','fontsize', 24);
    text(x(1),x(2),fo(x),'\leftarrow X','HorizontalAlignment','left','FontWeight','bold','Color','b','fontsize', 24);
    
    figure(4)
    surf(zx,zy,z);    
    view (0, 360);
    set(gca, 'linewidth', 10, 'fontsize', 24);    
    text(opt(1),opt(2),fo(opt),'\leftarrow opt','HorizontalAlignment','left','FontWeight','bold','Color','r','fontsize', 24);
    text(x0(1),x0(2),fo(x0),'\leftarrow X0','HorizontalAlignment','left','FontWeight','bold','Color','g','fontsize', 24);
    text(x(1),x(2),fo(x),'\leftarrow X','HorizontalAlignment','left','FontWeight','bold','Color','b','fontsize', 24);
    pause(.1);
    
  until(cIter>Iter)
    
    figure(5);
    subplot(2,2,1);
    plot( xp,dataPlot(:,1)','linestyle','none','marker','.','markersize',20,'markerfacecolor',[0,0,1],
          xp,dataPlot(:,2)','linestyle',':','linewidth',5,'marker','.','markersize',15,'markerfacecolor',[0,1,0.5],
          xp,dataPlot(:,3)','linestyle','none','marker','.','markersize',10,'markerfacecolor',[1,0,0]);
    set(gca, 'linewidth', 3, 'fontsize', 24);
    
    subplot(2,2,2);
    plot(xp,dataPlot(:,4)','r-','lineWidth', 5);
    ylim([0 200]);
    
    subplot(2,2,3);
    surf(zx,zy,z);
    set(gca, 'linewidth', 10, 'fontsize', 24);    
    text(opt(1),opt(2),fo(opt),'\leftarrow opt','HorizontalAlignment','left','FontWeight','bold','Color','r','fontsize', 24);
    text(x0(1),x0(2),fo(x0),'\leftarrow X0','HorizontalAlignment','left','FontWeight','bold','Color','g','fontsize', 24);
    text(x(1),x(2),fo(x),'\leftarrow X','HorizontalAlignment','left','FontWeight','bold','Color','b','fontsize', 24);
    
    subplot(2,2,4);
    surf(zx,zy,z);
    view (0, 360);
    set(gca, 'linewidth', 10, 'fontsize', 24);    
    text(opt(1),opt(2),fo(opt),'\leftarrow opt','HorizontalAlignment','left','FontWeight','bold','Color','r','fontsize', 24);
    text(x0(1),x0(2),fo(x0),'\leftarrow X0','HorizontalAlignment','left','FontWeight','bold','Color','g','fontsize', 24);
    text(x(1),x(2),fo(x),'\leftarrow X','HorizontalAlignment','left','FontWeight','bold','Color','b','fontsize', 24);
	  
  
end