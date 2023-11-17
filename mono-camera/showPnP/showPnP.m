function result = showPnP( pnpmatrix ,fx,fy,cx,cy,screen_z)

%  pnpMatrix is Twc  which Transform Point from world space to camera space
%             Pc = Twc * Pw
%  fx,fy   focal length w.r.t  horizontal and vertical 
%  cx,cy   optical axis position in screen
%  screen_z  locate screen z poistion w.r.t camera center
%


%draw 3D Point
plot3([-0.5,-0.5,0.5,0.5,-0.5],[-0.5,0.5,0.5,-0.5,-0.5],[0,0,0,0,0],'LineWidth',1,'Color','b')
text(-0.5,-0.5,0,'a1','HorizontalAlignment','left')
text(-0.5,0.5,0,'a2','HorizontalAlignment','left')
text(0.5,0.5,0,'a3','HorizontalAlignment','right')
text(0.5,-0.5,0,'a4','HorizontalAlignment','right')


%text o-axis
text(1,0,0,'Xw','HorizontalAlignment','right')
text(0,1,0,'Yw','HorizontalAlignment','right')
text(0,0,1,'Zw','HorizontalAlignment','right')
%draw camera frame
% x- 'r'  y- 'g' z- 'b'
Fc = [1,0,0;0,1,0;0,0,1;1,1,1];
Tcw = inv(pnpmatrix);
Fw = Tcw * Fc;

hold on
%plot x- axis
plot3([0,1],[0,0],[0,0],'LineWidth',2,'Color','r')

%plot y- axis
plot3([0,0],[0,1],[0,0],'LineWidth',2,'Color','g')

%plot z- axis
plot3([0,0],[0,0],[0,1],'LineWidth',2,'Color','b')


%ploat camera
%plot x- axis
plot3([Tcw(1,4),Fw(1,1)],[Tcw(2,4),Fw(2,1)],[Tcw(3,4),Fw(3,1)],'LineWidth',1,'Color','r')

%plot y- axis
plot3([Tcw(1,4),Fw(1,2)],[Tcw(2,4),Fw(2,2)],[Tcw(3,4),Fw(3,2)],'LineWidth',1,'Color','g')

%plot z- axis
plot3([Tcw(1,4),Fw(1,3)],[Tcw(2,4),Fw(2,3)],[Tcw(3,4),Fw(3,3)],'LineWidth',1,'Color','b')

%text o-axis
text(Fw(1,1),Fw(2,1),Fw(3,1),'Xc','HorizontalAlignment','right')
text(Fw(1,2),Fw(2,2),Fw(3,2),'Yc','HorizontalAlignment','right')
text(Fw(1,3),Fw(2,3),Fw(3,3),'Zc','HorizontalAlignment','right')
%draw screen
% -0.6067,-1.0785,2
% -0.6067,1.0785,2
% 0.6067,1.0785,2
% 0.6067,-1.0785,2
scr_w = cx*2/fx;
scr_h = cy*2/fy;

Pscreen_c = [-scr_w,-scr_w,scr_w,scr_w;
                scr_h,-scr_h,scr_h,-scr_h;
                   screen_z,screen_z,screen_z,screen_z;
                   1,1,1,1];

Pscreen_w = Tcw * Pscreen_c;
XX=reshape(Pscreen_w(1,:),[2,2]);
YY=reshape(Pscreen_w(2,:),[2,2]);
ZZ = reshape(Pscreen_w(3,:),[2,2]);
surf(XX,YY,ZZ,'FaceAlpha',0.5)
text(Pscreen_w(1,3),Pscreen_w(2,3),Pscreen_w(3,3),'Screen','HorizontalAlignment','right')

%draw link
plot3([Tcw(1,4),-0.5],[Tcw(2,4),-0.5],[Tcw(3,4),0],'LineWidth',1,'Color',[0,0,0])
plot3([Tcw(1,4),-0.5],[Tcw(2,4),0.5],[Tcw(3,4),0],'LineWidth',1,'Color',[0,0,0])
plot3([Tcw(1,4),0.5],[Tcw(2,4),0.5],[Tcw(3,4),0],'LineWidth',1,'Color',[0,0,0])
plot3([Tcw(1,4),0.5],[Tcw(2,4),-0.5],[Tcw(3,4),0],'LineWidth',1,'Color',[0,0,0])


[Offset ,check1] =  plane_line_intersect([0,0,1],[0,0,0],[Tcw(1,4),Tcw(2,4),Tcw(3,4)],Fw(1:3,3).');

%screen norm
n = [Fw(1,3)-Offset(1,1),Fw(2,3)-Offset(1,2),Fw(3,3)]
% point in screen plane
V0 = reshape(Pscreen_w(1:3,1),[1,3]);


[aa1 ,check1] =  plane_line_intersect(n,V0,[Tcw(1,4),Tcw(2,4),Tcw(3,4)],[-0.5,-0.5,0]);
[aa2 ,check2] =  plane_line_intersect(n,V0,[Tcw(1,4),Tcw(2,4),Tcw(3,4)],[-0.5,0.5,0]);
[aa3 ,check3] =  plane_line_intersect(n,V0,[Tcw(1,4),Tcw(2,4),Tcw(3,4)],[0.5,0.5,0]);
[aa4 ,check4] =  plane_line_intersect(n,V0,[Tcw(1,4),Tcw(2,4),Tcw(3,4)],[0.5,-0.5,0]);

MM = [aa1.',aa2.',aa3.',aa4.',aa1.'];
plot3(MM(1,:),MM(2,:),MM(3,:),'LineWidth',1,'Color',[0,0,0])



xlabel('X') % x-axis label
ylabel('Y') % y-axis label
zlabel('Z') % x-axis label

axis([-7 7 -7 7 -7 7])
grid on
end
function [I,check]=plane_line_intersect(n,V0,P0,P1)
%plane_line_intersect computes the intersection of a plane and a segment(or
%a straight line)
% Inputs: 
%       n: normal vector of the Plane 
%       V0: any point that belongs to the Plane 
%       P0: end point 1 of the segment P0P1
%       P1:  end point 2 of the segment P0P1
%
%Outputs:
%      I    is the point of interection 
%     Check is an indicator:
%      0 => disjoint (no intersection)
%      1 => the plane intersects P0P1 in the unique point I
%      2 => the segment lies in the plane
%      3=>the intersection lies outside the segment P0P1
%
% Example:
% Determine the intersection of following the plane x+y+z+3=0 with the segment P0P1:
% The plane is represented by the normal vector n=[1 1 1]
% and an arbitrary point that lies on the plane, ex: V0=[1 1 -5]
% The segment is represented by the following two points
% P0=[-5 1 -1]
%P1=[1 2 3]   
% [I,check]=plane_line_intersect([1 1 1],[1 1 -5],[-5 1 -1],[1 2 3]);

%This function is written by :
%                             Nassim Khaled
%                             Wayne State University
%                             Research Assistant and Phd candidate
%If you have any comments or face any problems, please feel free to leave
%your comments and i will try to reply to you as fast as possible.

I=[0 0 0];
u = P1-P0;
w = P0 - V0;
D = dot(n,u);
N = -dot(n,w);
check=0;
if abs(D) < 10^-7        % The segment is parallel to plane
        if N == 0           % The segment lies in plane
            check=2;
            return
        else
            check=0;       %no intersection
            return
        end
end

%compute the intersection parameter
sI = N / D;
I = P0+ sI.*u;

if (sI < 0 || sI > 1)
    check= 3;          %The intersection point  lies outside the segment, so there is no intersection
else
    check=1;
end
end
