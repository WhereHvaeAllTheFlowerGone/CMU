a=0.5; D1=60; D2=15; l=15; m=6000;
g=9.8; Tmax=20000*g; 
t1=5; t2=5; t3=5;%此时t为每段的时间间隔
xa1=a*t1*t1/2; xa2=xa1+a*t1*t2; xa3=xa2+t3*(2*t1-t3)*a/2; xa4=D1+D2-xa3;
t4=xa4/(xa3+a*(t1-t3)); %xai为第i段结束后吊车的位移
t2=t2+t1; t3=t2+t3; t4=t3+t4;%此时t为每段结束的时刻
t=cell(4,1); theta=cell(4,1); x=cell(4,1); T=cell(4,1);%时间，角度，横坐标，拉力

dydt=@(t,y)[ y(2) ; (-a*y(2)*t*sin(y(1))+a*cos(y(1))-g*sin(y(1)))/l ];
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
[t{1},theta{1}] = ode45(dydt,[0,t1],[0 0],options);
x{1}=0.5*a*t{1}.^2-l*sin(theta{1}(:,1));
%plot(t{1},theta{1})

dydt=@(t,y)[ y(2) ; -(g/l)*sin(y(1)) ];
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
[t{2},theta{2}] = ode45(dydt,[t1,t2],[theta{1}(length(theta{1}(:,1)),1) theta{1}(length(theta{1}(:,2)),2)],options);
x{2}=xa1+a*t1*(t{2}-t1)-l*sin(theta{2}(:,1));
%plot(t{2},theta{2})

dydt=@(t,y)[ y(2) ; (-a*y(2)*(t1+t2-t)*sin(y(1))-a*cos(y(1))-g*sin(y(1)))/l ];
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
[t{3},theta{3}] = ode45(dydt,[t2,t3],[theta{2}(length(theta{2}(:,1)),1) theta{2}(length(theta{2}(:,2)),2)],options);
x{3}=xa2+a*t1*(t{3}-t2)-0.5*a*(t{3}-t2).^2-l*sin(theta{3}(:,1));
%plot(t{3},theta{3})

dydt=@(t,y)[ y(2) ; -(g/l)*sin(y(1)) ];
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
[t{4},theta{4}] = ode45(dydt,[t3,t4],[theta{3}(length(theta{3}(:,1)),1) theta{3}(length(theta{3}(:,2)),2)],options);
x{4}=xa3+a*(t1+t2-t3)*(t{4}-t3)-l*sin(theta{4}(:,1));
%plot(t{4},theta{4})

for i=1:4
    plot(t{i},theta{i}(:,1));
    hold on;
end