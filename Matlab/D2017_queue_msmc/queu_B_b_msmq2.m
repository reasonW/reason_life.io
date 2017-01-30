%% 这个B 区域多服务多队列
 % state_a_b=randsrc(1,47,b_b_ser_time1);
% state_b_b=randsrc(1,47,b_b_ser_time2);
state_a_b=abs(exprnd(7.542,1,arr_num));
state_b_b=abs(exprnd(7.542,1,arr_num));

%st=exprnd(2.5,1,n); %服务台服务时间
bb1_a=zeros(1,arr_num); %每个包裹到达时间
bb2_a=zeros(1,arr_num); %每个包裹开始接受服务时间   -> events(3,:)
bb3_a=zeros(1,arr_num);%每个包裹离开时间            -> events(4,:)
bb4_a=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
bb5_a=zeros(1,arr_num);% 标识位是否进入复查
aerfa=0.02;
bb1_b=zeros(1,arr_num); %每个包裹到达时间
bb2_b=zeros(1,arr_num); %每个包裹开始接受服务时间   -> events(3,:)
bb3_b=zeros(1,arr_num);%每个包裹离开时间            -> events(4,:)
bb4_b=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
bb5_b=zeros(1,arr_num);% 标识位是否进入复查

bb1_a(1)=0;
% for i=2:arr_num
%   a1(i)=a1(i-1)+dt(i-1);%第i个包裹到达时间  -> events(1,:)
% end
arr_time_b=a3;
bb1_a(1)=arr_time_b(1);%第1个包裹到达时间
bb1_b(1)=arr_time_b(2);%第1个包裹到达时间
bb2_a(1)=arr_time_b(1);%第1个包裹开始接受服务时间为到达时间
bb2_b(1)=arr_time_b(2);%第1个包裹开始接受服务时间为到达时间
bb3_a(1)=bb2_a(1)+state_a_b(1); %第1个包裹离开时间
bb3_b(1)=bb2_b(1)+state_b_b(1); %第1个包裹离开时间
bb4_a(1)=1;%一个顾客,标志位置为1
bb4_b(1)=1;%一个顾客,标志位置为1
bb5_a(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
bb5_b(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);

%其进入系统后，系统内已有成员序号为 1
member_A_b_b = [1];
member_B_b_b = [1];
bottleBb=zeros(1,10);
bottleBb(1)=0;
bottleBb(2)=0;
DeteBb=0;
DeteBb_t=[];
Pointer=2;

for i=3:arr_num
    if bb4_a(length(member_A_b_b))<=bb4_b(length(member_B_b_b))
        member_A_b_b=[member_A_b_b,length(member_A_b_b)+1];
        len_A_mem_b_b=length(member_A_b_b);
        bb1_a(len_A_mem_b_b)=arr_time_b(i);
        number=sum(bb3_a(1:len_A_mem_b_b-1)>=bb1_a(len_A_mem_b_b));
          if number ==0
            bb2_a(len_A_mem_b_b)=bb1_a(len_A_mem_b_b);
            bb3_a(len_A_mem_b_b)=bb1_a(len_A_mem_b_b)+state_a_b(len_A_mem_b_b);
            bb4_a(len_A_mem_b_b)=1;
            bb5_a(len_A_mem_b_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          else
            bb2_a(len_A_mem_b_b)=bb3_a(len_A_mem_b_b-1);
            bb3_a(len_A_mem_b_b)=bb2_a(len_A_mem_b_b)+state_a_b(len_A_mem_b_b);
            bb4_a(len_A_mem_b_b)=number+1;
            bb5_a(len_A_mem_b_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          end
          bottleBb(rem(Pointer+1,10)+1)=bb2_a(len_A_mem_b_b)-bb1_a(len_A_mem_b_b);
          Pointer=Pointer+1;
    else
         member_B_b_b=[member_B_b_b,length(member_B_b_b)+1];
         len_B_mem_b_b=length(member_B_b_b);
         bb1_b(len_B_mem_b_b)=arr_time_b(i);
         number=sum(bb3_b(1:len_B_mem_b_b-1)>=bb1_b(len_B_mem_b_b));
          if number ==0
            bb2_b(len_B_mem_b_b)=bb1_b(len_B_mem_b_b);
            bb3_b(len_B_mem_b_b)=bb1_b(len_B_mem_b_b)+state_b_b(len_B_mem_b_b);
            bb4_b(len_B_mem_b_b)=1;
            bb5_b(len_B_mem_b_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          else
            bb2_b(len_B_mem_b_b)=bb3_b(len_B_mem_b_b-1);
            bb3_b(len_B_mem_b_b)=bb2_b(len_B_mem_b_b)+state_b_b(len_B_mem_b_b);
            bb4_b(len_B_mem_b_b)=number+1;
            bb5_b(len_B_mem_b_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          end
          bottleBb(rem(Pointer+1,10)+1)=bb2_b(len_B_mem_b_b)-bb1_b(len_B_mem_b_b);
          Pointer=Pointer+1;
    end
    if (MODEL==1)
        if sum(bottleBb)/10>6.31
%          fprintf('B bag area %f people waiting long %f \n',i,sum(bottleA)/20);
            DeteBb=DeteBb+1;
            DeteBb_t=[DeteBb_t,sum(bottleBb)/10];
        end
    else
        if sum(bottleBb)/10>8.11
%            fprintf('B bag area %f people waiting long %f \n',i,sum(bottleA)/20);
           DeteBb=DeteBb+1;
           DeteBb_t=[DeteBb_t,sum(bottleBb)/10];
        end
    end
end
%% demo_绘图
len_A_mem_b_b = length(member_A_b_b);
len_B_mem_b_b = length(member_B_b_b);
bb1=[bb1_a(1:len_A_mem_b_b) bb1_b(1:len_B_mem_b_b)];
bb2=[bb2_a(1:len_A_mem_b_b) bb2_b(1:len_B_mem_b_b)];
bb3=[bb3_a(1:len_A_mem_b_b) bb3_b(1:len_B_mem_b_b)];
bb4=[bb4_a(1:len_A_mem_b_b) bb4_b(1:len_B_mem_b_b)];
b_tmp=[bb1;bb2;bb3;bb4];
b_tmp_=sortrows(b_tmp',1);
b_tmp=b_tmp_';
bb1=b_tmp(1,:);
bb2=b_tmp(2,:);
bb3=b_tmp(3,:);
bb4=b_tmp(4,:);
%仿真结束时，进入系统的总顾客数
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs(0:arr_num_b,[0 bb1],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:arr_num_b,[0 bb3 ],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('B_b arriving time','B_b leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
B_cost_time_b=zeros(1,arr_num); %记录每个包裹在系统逗留时间
B_wait_time_b=zeros(1,arr_num); %记录每个包裹在系统等待时间
for i=1:arr_num
  B_cost_time_b(i)=bb3(i)-bb1(i); %第i个包裹在系统逗留时间
  B_wait_time_b(i)=bb2(i)-bb1(i); %第i个包裹在系统等待时间
end

%%
%demo
% plot(x,y,'o-','linewidth',2, 'MarkerFaceColor','g','markersize',4);
% title('传播速度')
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
%% x_输出
% T1=bb3_a(len_A_mem_b_b)+bb3_b(len_B_mem_b_b)%总时间
% p1=sum(state_a_b(member_A_b_b))/T1+sum(state_a_b(member_A_b_b))/T1 %服务率
% avert1=sum(B_wait_time_b)/(sum(state_a_b(member_A_b_b)))%每个包裹系统平均逗留时间
% fprintf('B passenager averager cost time%fs\n',avert1);
% fprintf('B system working intensity %f\n',p1);

%% D 区复查
if sum(ba5_a)+sum(ba5_b)==0
    ba5_a(1)=1;
end

da1_b=zeros(1,sum(bb5_a)+sum(bb5_b));
index=find(bb5_a==1);
for i=1:sum(bb5_a)
    da1_b(i)=bb3_a(index(i));
end
index=find(bb5_b==1);n=1;
for i=sum(bb5_a)+1:sum(bb5_a)+sum(bb5_b)
    da1_b(i)=bb3_b(index(n));
    n=n+1;
end
da1_b=sort(da1_b);


